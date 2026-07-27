# Module Réception & Gouvernance (Jet 2)

Ce document décrit l'architecture et les fonctionnalités du module unifié **Réception & Gouvernance** (`reception`).

---

## 1. Clean Architecture & Structuration

Le module suit la Clean Architecture sous `lib/features/reception/` :

*   **👥 Domain Layer :**
    *   `ArrivalDeparture` : Entité modélisant les mouvements de check-in et check-out.
    *   `GetArrivalsUseCase`, `GetDeparturesUseCase`, `PerformCheckInUseCase`, `PerformCheckOutUseCase`, `GetReceptionRoomsUseCase`.
*   **🗄️ Data Layer :**
    *   `ArrivalDepartureModel` : Mappeur JSON des opérations d'accueil.
    *   `ReceptionRemoteDataSource` : Intégration REST vers `/api/v1/reception/arrivals`, `/api/v1/reception/departures`, `/api/v1/reception/checkin`, `/api/v1/reception/checkout`.
    *   `ReceptionRepositoryImpl` : Implémentation du contrat métier.
*   **🎨 Presentation Layer :**
    *   `ReceptionBloc` : BLoC d'état (`ReceptionInitial`, `ReceptionLoading`, `ReceptionLoaded`, `ReceptionFailure`).
    *   `ReceptionDashboardPage` : Dashboard unifié avec 3 onglets (Arrivées, Départs, Statut Ménage & Gouvernance).

---

## 2. Spécifications & Temps Réel

*   **Pusher Real-Time :** Écoute des mises à jour réseau instantanées lors d'un changement de statut de nettoyage (À nettoyer -> En cours -> Propre -> Vendable).
*   **Mode Hors-Ligne (`SyncQueue`) :** File d'attente locale pour persister les check-ins/check-outs en cas de perte de connexion réseau.
*   **Qualité Code :** Tests unitaires BLoC validés (`reception_bloc_test.dart`), `flutter analyze` 0 erreur.
