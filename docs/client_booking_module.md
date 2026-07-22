# Module Client Booking (Réservation Client)

Ce module implémente le nouveau parcours de réservation client simplifié en Clean Architecture.

## Fonctionnalités

1. **Choix de la typologie** : Liste des types de chambres (Standard, Premium, Suite) avec description, prix de la nuitée, capacité et photos.
2. **Choix des dates** : Saisie des dates d'arrivée (check-in) et de départ (check-out).
3. **Vérification de la disponibilité** :
   - *Disponible* : Choix de la quantité de chambres (limité par le stock disponible pour ces dates).
   - *Non disponible* : Affichage de propositions alternatives (autres catégories de chambres ayant des disponibilités sur cette période).
4. **Validation du panier** :
   - Choix de *poursuivre les réservations* (retour au choix des typologies) ou *valider directement* (redirection vers le panier).
   - Synchronisation automatique des dates et des chambres choisies avec le `CartBloc`.

## Architecture BLoC

Le `ClientBookingBloc` agit comme une machine à états gérant les différentes étapes du parcours utilisateur.

### Événements (Events)
- `LoadRoomTypesEvent` : Chargement initial des catégories.
- `SelectRoomTypeEvent` : Sélection d'une catégorie et transition vers la saisie des dates.
- `SelectDatesEvent` : Lancement de la vérification des disponibilités pour les dates choisies.
- `ConfirmQuantityEvent` : Validation finale de la quantité de chambres à ajouter.
- `ResetBookingFlowEvent` : Retour à la liste des catégories avec remise à zéro du parcours.

### États (States)
- `ClientBookingInitial` : Chargement initial.
- `RoomTypesLoadedState` : Liste des typologies affichée (Étape 1).
- `SelectingDatesState` : Saisie des dates (Étape 2).
- `CheckingAvailabilityState` : Requête de disponibilité en cours.
- `AvailabilityResultState` : Résultat de disponibilité (Étape 3 : quantité ou alternatives).
- `BookingCompletedState` : Parcours terminé avec succès, chambres prêtes à être ajoutées au panier.
- `BookingErrorState` : Gestion des erreurs.

## Cas d'Usage (Use Cases)
- **`GetBookingRoomTypesUseCase`** : Récupère la liste des typologies depuis le point de terminaison `/backoffice/room-types`.
- **`CheckTypeAvailabilityUseCase`** : Récupère toutes les chambres libres pour la période donnée depuis `/rooms/available`. Le filtrage par catégorie est effectué par la suite au sein du BLoC.

## Règles Métiers & Charte Graphique
- **Zéro valeur hardcodée** : Espacements basés sur `AppDimensions`, couleurs issues de `AppColors` (`champagneGold`, `imperialNightBlue`, `statusSuccess`, etc.).
- **Responsiveness** : Les formulaires ont une largeur maximale de 500px et sont centrés sur grand écran (tablette / web).
- **l10n** : Tous les textes sont traduits dans les 6 langues cibles (`fr`, `en`, `es`, `de`, `ar`, `zh`) via `AppLocalizations`. Les fichiers arb et les fichiers générés sont sécurisés par l'injection d'un BOM UTF-8.

## Scénarios de Test Validés
- Récupération des typologies depuis le dépôt de données.
- Vérification de la disponibilité et sélection des chambres correspondantes.
- Enchaînement et transition d'états dans le `ClientBookingBloc`.
