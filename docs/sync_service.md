# Guide d'Implémentation du Service de Reprise Réseau (Synchronisation)

Ce document décrit le fonctionnement et l'implémentation de la persistance locale et de la file d'attente de synchronisation asynchrone (mode dégradé hors-ligne) pour le personnel terrain.

---

## 1. Principe de Fonctionnement (Offline-First)

Lorsqu'une action d'écriture (mise à jour d'état de chambre, commande room service, dotation équipement) est effectuée par un membre du staff sur le terrain :
1. L'application vérifie la connectivité réseau.
2. Si le réseau est déconnecté ou si l'appel API échoue (timeout), l'écriture est effectuée localement dans la base SQLite locale.
3. Une entrée décrivant l'action à synchroniser est insérée dans la table SQLite `sync_queue` avec le flag `sync_status` mis à `0` (False).
4. Un service d'écoute réseau (`ConnectivityListener`) détecte le retour de la connexion internet.
5. Dès la reprise réseau, le service de synchronisation extrait séquentiellement les tâches de `sync_queue`, les pousse vers le Core Back-end FastAPI, et met à jour le statut ou supprime l'enregistrement une fois validé par le serveur.

---

## 2. La Table `sync_queue`

Le schéma SQLite de la file de synchronisation est défini dans [local_database.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/database/local_database.dart) :
```sql
CREATE TABLE sync_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  table_name TEXT,             -- Table concernée (ex: 'chambres')
  action_type TEXT,            -- Type de requête (ex: 'INSERT', 'UPDATE', 'DELETE')
  record_id TEXT,              -- Identifiant unique (UUID ou ID de chambre)
  payload TEXT,                -- Données sérialisées en JSON de l'entité
  sync_status INTEGER DEFAULT 0 -- 0 = FALSE (en attente), 1 = TRUE (synchronisé)
)
```

---

## 3. Algorithme de Synchronisation (Background Processor)

Le traitement de la file de synchronisation doit être géré de manière séquentielle pour préserver l'ordre chronologique des écritures (FIFO - First In, First Out).

### Squelette d'implémentation suggéré :

```dart
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sra_hotel/core/database/local_database.dart';
import 'package:sra_hotel/core/network/api_client.dart';

class SyncService {
  final LocalDatabase localDatabase;
  final ApiClient apiClient;
  bool _isSyncing = false;

  SyncService({required this.localDatabase, required this.apiClient}) {
    // Écouteur de connectivité
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        triggerQueueProcessing();
      }
    });
  }

  Future<void> triggerQueueProcessing() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final db = await localDatabase.database;
      // Récupérer les actions non synchronisées par ordre chronologique
      final List<Map<String, dynamic>> queue = await db.query(
        'sync_queue',
        where: 'sync_status = 0',
        orderBy: 'id ASC',
      );

      for (var task in queue) {
        final int id = task['id'];
        final String tableName = task['table_name'];
        final String actionType = task['action_type'];
        final String recordId = task['record_id'];
        final Map<String, dynamic> payload = jsonDecode(task['payload']);

        bool success = false;
        
        // Router l'action vers le bon endpoint de l'API
        try {
          if (tableName == 'chambres' && actionType == 'UPDATE') {
            final response = await apiClient.put('/rooms/$recordId/status', data: payload);
            success = response.statusCode == 200;
          }
          // Ajouter les autres routes au besoin...
          
          if (success) {
            // Supprimer ou marquer comme synchronisé
            await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
          }
        } catch (e) {
          // Erreur réseau (ex: timeout) : stopper la file pour retenter plus tard
          break;
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
```

---

## 4. Consignes pour les Développeurs

- **Enregistrement de modifications locales :** Lorsque vous modifiez un statut localement (ex: le statut de ménage d'une chambre), faites toujours l'écriture SQLite de la table (`chambres`), puis insérez l'action de synchronisation correspondante dans la table `sync_queue` au sein de la même transaction locale.
- **Gestion des conflits :** Le serveur FastAPI reste la source de vérité principale. Si l'API retourne un code d'erreur `409 Conflict` ou `400 Bad Request` lors de la synchronisation, le traitement local doit être écrasé par les données renvoyées par le serveur.
