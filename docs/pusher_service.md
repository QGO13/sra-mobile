# Guide d'Intégration du Temps Réel avec Pusher

Ce document décrit le fonctionnement et l'intégration du flux d'événements temps réel pour les notifications et les alertes internes (cuisine, réception, gouvernance).

---

## 1. Principe Général

L'application utilise le package `pusher_channels_flutter` pour s'abonner aux événements asynchrones émis par le back-end FastAPI.
- **Canaux Publics :** Utilisés pour les annonces générales ou la disponibilité globale.
- **Canaux Privés (`private-`) :** Exigent une authentification préalable. L'application transmet son jeton JWT dans les en-têtes lors de la requête de handshake d'autorisation vers FastAPI.

---

## 2. Configuration Initiale

Le service Pusher doit être initialisé après la validation réussie de la session de l'utilisateur.

### Squelette d'implémentation du service :

```dart
import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sra_hotel/core/constants/app_constants.dart';

class PusherService {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final String _apiKey = "VOTRE_CLÉ_PUSHER";
  final String _cluster = "eu"; // cluster d'hébergement

  Future<void> initialize(String jwtToken) async {
    try {
      await _pusher.init(
        apiKey: _apiKey,
        cluster: _cluster,
        // Point de validation pour les canaux privés
        authEndpoint: "${AppConstants.apiBaseUrl}/auth/pusher", 
        authParams: {
          'headers': {
            'Authorization': 'Bearer $jwtToken',
          }
        },
        onEvent: _onEventReceived,
      );
      
      await _pusher.connect();
    } catch (e) {
      // Gérer l'échec de connexion
    }
  }

  // Écoute de tous les événements des canaux abonnés
  void _onEventReceived(PusherEvent event) {
    final Map<String, dynamic> data = jsonDecode(event.data);
    
    switch (event.eventName) {
      case 'new-order':
        _handleNewKitchenOrder(data);
        break;
      case 'status-changed':
        _handleRoomStatusChanged(data);
        break;
      case 'stock-alert':
        _handleCriticalStockAlert(data);
        break;
    }
  }

  Future<void> subscribeToChannel(String channelName) async {
    await _pusher.subscribe(channelName: channelName);
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    await _pusher.unsubscribe(channelName: channelName);
  }

  void _handleNewKitchenOrder(Map<String, dynamic> data) {
    // Diffuser l'alerte à la cuisine (via Event Bus ou BLoC)
  }

  void _handleRoomStatusChanged(Map<String, dynamic> data) {
    // Diffuser l'événement pour mettre à jour la grille Gantt du PMS en direct
  }

  void _handleCriticalStockAlert(Map<String, dynamic> data) {
    // Afficher une alerte ou notification d'inventaire
  }
}
```

---

## 3. Liste des Canaux Métiers

Le système de notifications écoute les canaux suivants selon le rôle de l'utilisateur connecté :

| Canal | Rôle Requis | Description / Événement |
| :--- | :--- | :--- |
| `private-restaurant-kitchen` | `'serveur'`, `'admin'` | Événement `new-order` émis lors de la commande d'un Room Service ou d'une note de restaurant. |
| `private-pms-gantt` | `'receptionniste'`, `'admin'` | Événement `booking-updated` ou `room-maintenance` pour rafraîchir en temps réel le Gantt. |
| `private-governance` | `'gouvernante'`, `'femme_de_chambre'` | Événement `status-changed` notifiant le passage d'une chambre à l'état "À nettoyer" ou "Nettoyé". |
| `private-inventory` | `'admin'` | Événement `stock-alert` émis lors de la décrémentation sous le seuil critique d'un ingrédient ou produit. |

---

## 4. Consignes pour les Développeurs

- **Cycle de vie de connexion :** Ne lancez la connexion Pusher qu'après une authentification réussie. En cas de déconnexion (logout), veillez à appeler explicitement la déconnexion Pusher pour éviter les fuites de ressources.
- **Réaction graphique :** Les événements Pusher reçus doivent déclencher l'ajout d'un événement dans vos BLoCs correspondants pour forcer la mise à jour réactive des écrans (par exemple, le `BookingBloc` pour recharger la vue planning Gantt).
