# Module Room Assignment (Affectation des Chambres) — Documentation

Ce document détaille l'implémentation, l'architecture et les règles métier du module de gestion des affectations des chambres de l'application SRA Hôtel.

---

## 1. Fonctionnalités
Le module offre une interface d'administration complète et réactive avec quatre modes de visualisation :
1. **Visio Planning (Gantt) :**
   - Grille bidimensionnelle interactive avec défilement horizontal et vertical synchronisé (Sticky Rooms).
   - Affiche les réservations sous forme de barres horizontales colorées calculées dynamiquement selon les dates de check-in et check-out.
   - Clic sur une barre pour ouvrir le formulaire de modification de la réservation.
2. **Tableau Kanban :**
   - Colonnes de statut (`En attente`, `Confirmée`, `En séjour`, `Terminée`, `Annulée`).
   - Cartes de réservations éditables avec raccourcis contextuels pour changer le statut d'une réservation en un clic.
3. **Vue Calendrier Mensuelle :**
   - Calendrier mensuel affichant pour chaque jour le volume de chambres occupées.
   - Volet inférieur listant les mouvements du jour sélectionné (Arrivées/Check-ins, Départs/Check-outs, Clients en séjour).
4. **Liste des Réservations :**
   - Recherche textuelle instantanée (nom, référence, chambre, type de chambre) et filtres par ChoiceChips.

---

## 2. Architecture & Composants (Clean Architecture)

Le module est découpé selon les couches strictes définies dans `AGENTS.md` :

### A. Couche Domain
- **Repository :** [RoomAssignmentRepository](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/domain/repositories/room_assignment_repository.dart) définit le contrat.
- **Use Cases :**
  - [GetAssignmentDataUseCase](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/domain/usecases/get_assignment_data_usecase.dart) : Charge les chambres et réservations en parallèle.
  - [UpdateAssignmentUseCase](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/domain/usecases/update_assignment_usecase.dart) : Met à jour la réservation modifiée.

### B. Couche Data
- **Datasource :** [RoomAssignmentRemoteDataSourceImpl](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/data/datasources/room_assignment_remote_datasource.dart) effectue les appels HTTP via `ApiClient`. Parsing défensif gérant les formats bruts (mock) et enveloppés.
- **Repository Impl :** [RoomAssignmentRepositoryImpl](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/data/repositories/room_assignment_repository_impl.dart) convertit les entités et modèles.

### C. Couche Presentation
- **BLoC :** [RoomAssignmentBloc](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/bloc/room_assignment_bloc.dart) gère le chargement, la modification et l'annulation.
- **Page principale :** [RoomAssignmentDashboardPage](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/pages/room_assignment_dashboard_page.dart) (onglet horizontal TabBar).
- **Widgets spécifiques :**
  - [VisioPlanningWidget](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/widgets/visio_planning_widget.dart) (Gantt Timeline).
  - [AssignmentKanbanWidget](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/widgets/assignment_kanban_widget.dart) (Kanban).
  - [AssignmentCalendarWidget](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/widgets/assignment_calendar_widget.dart) (Calendrier).
  - [AssignmentListWidget](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/widgets/assignment_list_widget.dart) (Liste).
  - [EditAssignmentDialog](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/features/room_assignment/presentation/widgets/edit_assignment_dialog.dart) (Formulaire d'édition).

---

## 3. Règles Métier & Anti-Overbooking
Lors de l'attribution ou du décalage de dates d'une réservation, la boîte de dialogue de modification effectue une vérification en temps réel pour lister uniquement les chambres réellement libres sur l'intervalle `[checkIn, checkOut)` choisi :
- Condition d'exclusion d'une chambre :
  $$\text{checkIn}_{\text{nouveau}} < \text{checkOut}_{\text{existant}} \quad \text{ET} \quad \text{checkOut}_{\text{nouveau}} > \text{checkIn}_{\text{existant}}$$
  Pour toute réservation existante active sur cette même chambre (hors la réservation en cours d'édition).

---

## 4. Tests unitaires validés
Les scénarios suivants ont été implémentés dans [room_assignment_bloc_test.dart](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/test/features/room_assignment/presentation/bloc/room_assignment_bloc_test.dart) :
- Initialisation correcte du BLoC au statut `RoomAssignmentInitial`.
- Transition fluide `RoomAssignmentLoading` $\to$ `RoomAssignmentLoaded` lors du chargement des données.
- Succès d'enregistrement de modification avec transition `RoomAssignmentActionSuccess` $\to$ `RoomAssignmentLoaded` de rechargement.
- Succès d'annulation d'une réservation.
