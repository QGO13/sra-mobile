# Module de Recherche, Anti-Overbooking et Gestion du Panier (Jet 1, Modules 2, 3 & 4)

Ce document décrit le fonctionnement et la structure technique des modules de recherche de chambres (Module 2), de validation de surbooking (Module 3) et du panier d'achat multi-chambres (Module 4).

---

## 1. Structure du Code & Clean Architecture

Afin d'améliorer la modularité et d'isoler les responsabilités, le module `booking` a été découpé en deux modules distincts :

### A. Module de Recherche & Anti-Overbooking (`lib/features/room_search/`)
Gère la recherche de chambres et la vérification de surbooking.

*   **Entities :**
    *   `RoomEntity` : représente une chambre (numéro, catégorie, statut et tarif).
*   **Repositories :** `BookingRepository` définit les contrats de recherche (`searchAvailableRooms`) et de validation de surbooking (`verifyRoomAvailability`).
*   **UseCases :**
    *   `SearchRoomsUseCase` : récupère les chambres libres sur une plage de dates.
    *   `VerifyAvailabilityUseCase` : effectue la validation de surbooking temps réel.
*   **Models :** `RoomModel` gère le décodage JSON et l'encapsulation de la chambre.
*   **DataSources :**
    *   `BookingRemoteDataSource` : interroge l'API sur `/rooms/available` et `/rooms/verify-availability`.
    *   `BookingLocalDataSource` : met en cache les chambres dans SQLite locale (`chambres`, `type_de_chambre`).
*   **State Management (BLocs) :**
    *   `BookingBloc` : traite les requêtes de recherche et de vérification de surbooking.
*   **Presentation (UI) :**
    *   `RoomSearchPage` : formulaire de recherche épuré (dates, nombre d'adultes/enfants) avec boutons de validation Or/Crème.
    *   `RoomCard` : fiche chambre reprenant l'aspect de la fiche web (grande photo 16/9, Playfair Display, tags gris, prix doré, bouton contouré "RÉSERVER").

### B. Module de Panier (`lib/features/cart/`)
Gère la planification et la configuration du séjour avant paiement.

*   **Entities :**
    *   `CartItemEntity` : représente une chambre ajoutée au panier avec ses suppléments choisis (petit-déjeuner, lit d'appoint) et son helper de calcul de sous-total (`itemTotal`).
*   **State Management (BLocs) :**
    *   `CartBloc` : gère l'état du panier d'achat en mémoire (ajout, retrait, mise à jour des options et nombre de nuits).
*   **Presentation (UI) :**
    *   `CartPage` : affiche la liste des chambres choisies, les sous-totaux et permet de valider la réservation vers l'étape de facturation.
    *   `CartItemCard` : affiche les options disponibles (petit-déjeuner, lit d'appoint) sous forme de boutons à bascule ("pills") interactifs (remplaçant les anciennes cases à cocher).

---

## 2. Règles Métiers Strictes

Les règles imposées par la spécification sont entièrement vérifiées :

1.  **Validation Adulte :** La recherche impose de saisir au moins 1 adulte. Un validateur sur le champ bloque la soumission et affiche une erreur si le volume d'adultes est inférieur à 1.
2.  **Suggestion Enfant :** Si le nombre d'enfants saisis est supérieur à 0, l'interface affiche une alerte contextuelle suggérant automatiquement des typologies plus grandes (Suites ou Premium).
3.  **Lit d'appoint bridé :** L'option "Lit d'appoint" (Extra bed) n'est affichée et modifiable **que** si la typologie de la chambre est une Suite (`id_type_de_chambre == 3`). Elle est invisible et désactivée pour les chambres Standard et Premium.
4.  **Petit-déjeuner configurable :** Possibilité d'activer le petit-déjeuner par chambre dans le panier, et d'en configurer la quantité de personnes associées (+5 000 FCFA par personne et par nuit).

---

## 3. Moteur Anti-Overbooking & Ajout au Panier

Lorsqu'un utilisateur clique sur "RéSERVER" sur une fiche chambre :
1.  Un indicateur de chargement s'affiche sur la carte.
2.  Un événement `VerifyRoomRequested` est envoyé au `BookingBloc`, déclenchant l'appel API GET `/rooms/verify-availability`.
3.  Si l'API renvoie `available: true` :
    *   La chambre est automatiquement ajoutée au panier (`CartBloc`).
    *   Un message de type SnackBar apparaît avec un bouton d'accès rapide au panier ("VOIR PANIER").
    *   Un badge avec le nombre de chambres dans le panier s'affiche de manière réactive sur le bouton flottant au bas de l'écran de recherche.
4.  Si l'API renvoie `available: false` (conflit simulé pour la chambre **13** de test), l'ajout est bloqué et un popup d'erreur rouge informe l'utilisateur du conflit de surbooking évité.

---

## 4. Écran du Panier (`CartPage`)

La page `/cart` liste toutes les chambres réservées :
*   Chaque ligne propose de modifier le lit d'appoint (Suites uniquement) ou d'ajouter le petit-déjeuner pour N personnes via des pills interactifs or/mist.
*   Chaque modification recalcule le sous-total en temps réel.
*   Un récapitulatif détaillé en bas de page calcule :
    *   Le sous-total brut des chambres.
    *   Le total des suppléments (lits d'appoint, petits-déjeuners).
    *   Le total HT estimé.
*   Un bouton de validation permet d'engager le tunnel vers l'étape de facturation (`checkout`).
