# Module Espace Client & Mon Séjour (MyStay)

Ce document décrit l'architecture et les spécifications d'affichage de l'espace client **Mon Séjour & Suivi des Réservations** (`client_reservation` / `reservation_management`).

---

## 1. Ergonomie Mobile-First & Composants

*   **🏆 Hero Card Séjour (`StayHeroCard`) :** Carte immersive affichant la réservation active du client connecté (dates check-in/out, type de chambre, numéro attribué, décompte dynamique du temps restant et badge de statut).
*   **📍 Repères Touristiques & Services (`StayLandmarksCard`) :** Carte d'informations locales et services de l'hôtel (Wifi, Restaurant, Spa, Heures d'arrivée/départ).
*   **📜 Historique & Filtres Client (`ClientReservationsPage`) :** Liste dynamique avec filtres (`À venir`, `En séjour`, `Terminée`, `Annulée`) et recherche par référence ou typologie de chambre.

---

## 2. Conformité Design & Code Quality

*   **Design V2 Pixel-Perfect :** Police `Cormorant Garamond` pour les numéros de réservation et titres prestige, boutons arrondis `SraButton`, badges `SraStatusBadge`.
*   **Qualité Code :** `flutter analyze` sans erreur, 0 warning.
