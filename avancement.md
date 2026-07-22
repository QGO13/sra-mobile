## 1. Point de situation (Ce qui est fait vs Ce qu'il reste à faire)

### 🛠️ Ce qui a DÉJÀ été fait (Le Socle Technique)
- **Initialisation & Structure :** Projet Flutter créé sous le nom `sra_hotel` avec le package d'organisation `com.srah`. Structure Clean Architecture (`data`, `domain`, `presentation`) prête.
- **Charte Graphique :** Intégration du thème (Bleu Nuit `#0A192F` et Or Champagne `#D4AF37`) et des polices (Montserrat pour les titres, Poppins pour les textes) dans [app_theme.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/theme/app_theme.dart).
- **Internationalisation :** Configuration de 6 langues majeures (Français, Anglais, Espagnol, Arabe, Allemand, Chinois) sous `lib/l10n/`.
- **Widgets Communs :** Centralisation des éléments graphiques pour respecter la règle "zéro widget inline" : [sra_button.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/widgets/sra_button.dart), [sra_logo.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/widgets/sra_logo.dart), [language_selector.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/widgets/language_selector.dart) et [loading_indicator.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/widgets/loading_indicator.dart).
- **Base de Données Locale :** Implémentation complète des 14 tables relationnelles et de la file d'attente hors-ligne (`sync_queue`) dans [local_database.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/core/database/local_database.dart).
- **Module d'Authentification Modèle :** Création du répertoire [auth/](file:///d:/SRA-HOTEL/Dev/front_end_mobile/lib/features/auth/) avec entités, modèles, BLoC, et écriture transactionnelle SQLite (respectant l'héritage `personne` ➔ `users`).
- **Validation :** Code 100% propre sous `flutter analyze` et test unitaire [widget_test.dart](file:///d:/SRA-HOTEL/Dev/front_end_mobile/test/widget_test.dart) validé.

### 🧱 Ce qu'il reste à faire (Infrastructure Technique Avant Modules)
1. **Implémenter le `SyncService` :** Finaliser le service qui surveille la connexion réseau et vide la table `sync_queue` vers l'API.
2. **Implémenter le `PusherService` :** Brancher le client WebSocket pour écouter les canaux temps réel.
3. ~~**Configurer les Mocks API (Dio Interceptor) :** Créer l'intercepteur permettant de simuler les réponses API hors-ligne afin que l'équipe de dev puisse coder les écrans sans back-end actif.~~ (Fait)

---

## 2. Liste des Modules à Développer (Par Ordre de Priorité)

Le projet sera découpé selon les **4 Jets Agiles** prévus dans le cahier des charges, à réaliser séquentiellement :

### 🚀 JET 1 — Noyau PMS & Réservations Clients (Priorité Haute)
Ce bloc permet d'ouvrir les réservations aux clients et de valider le tunnel d'achat de nuitées.
1. **[x] Module Authentification & Profiling :** Écrans de Connexion / Inscription (Particulier, Corporate, Agence). [Terminé]
2. **[x] Recherche de Chambres & Grille Disponibilité :** Filtres par dates (arrivée/départ), typologies, volume d'adultes et d'enfants. [Terminé]
3. **[x] Moteur Anti-Overbooking (Côté Client) :** Validation instantanée de disponibilité via l'API. [Terminé]
4. **[x] Panier Multi-chambres :** Panier d'achat permettant d'ajouter plusieurs chambres et de configurer des suppléments (ex: petit-déjeuner, lit d'appoint bridé aux Suites). [Terminé]
5. **[x] Vérification Financière & Facture DGI (Client) :** Écran de pré-facture affichant le détail HT, TVA 18%, TST 2,5%, et Taxe de séjour (500 FCFA). [Terminé]
6. **[x] Passerelle de Paiement Mobile Money & Carte Bancaire (Client) :** Intégration du checkout FedaPay par numéro Mobile Money (+225 Côte d'Ivoire par défaut) et cartes de crédit. [Terminé]

### 📱 JET 2 — Opérations Terrain & Temps Réel (Priorité Moyenne-Haute)
Ce bloc outille le personnel dans l'hôtel pour gérer le service quotidien et le statut des chambres.
7. **Module Gouvernance (Smartphone Femme de chambre) :** Grille des chambres assignées et mise à jour rapide du statut (À nettoyer ➔ Nettoyé).
8. **Module Gouvernance (Tablette Gouvernante) :** Validation du statut (Nettoyé ➔ Confirmé ➔ Prêt/Vendable) avec alertes instantanées Pusher.
9. **Prise de Commandes Cuisine & Room Service :** Menu interactif pour le client et le staff en salle (choix obligatoire : Sur place, En chambre, En livraison).
10. **Module Cuisine (Écran Temps Réel) :** Réception et gestion des commandes (En préparation ➔ Prêt) synchronisées par Pusher.
11. **Imputation sur Chambre ("Mettre sur la chambre") :** Terminal serveur permettant d'ajouter une note de restaurant sur le folio d'une chambre active après saisie du numéro de chambre.

### 🏢 JET 3 — Espaces Professionnels, ERP & Comptabilité (Priorité Moyenne)
Ce bloc gère l'activité B2B et l'administration financière globale de l'établissement.
12. **Réservation de Salles & Séminaires :** Module de réservation de salles avec options d'inclusions (pauses café, repas d'affaires).
13. **Réservation Extérieure & Spa :** Module de privatisation de la piscine et planification des soins du spa.
14. **Comptabilité & Journaux ERP :** Vue d'administration affichant les journaux de vente et d'achat générés automatiquement (sans saisie manuelle).
15. **Inventaire Intelligent :** Module d'alertes en temps réel sur tablette admin lorsque la cuisine vend un plat et que les stocks d'ingrédients chutent sous le seuil critique.

### 🤖 JET 4 — Assistant IA, Indicateurs & Stores (Priorité Basse)
Finitions intelligentes, tableaux de bord de direction et mise en production.
16. **Assistant Concierge IA "Sweetie" :** Chatbot de conciergerie intégré pour les clients logés.
17. **Commandes Vocales :** Module audio permettant de commander au Room Service à la voix.
18. **Gamification client :** Écran de la "Roue de la fortune" pour fidéliser les clients.
19. **Tableaux de bord Direction :** Graphiques financiers pour la direction (RevPAR, Taux d'occupation).
20. **Déploiement final :** Build de production et publication sur l'App Store / Google Play.