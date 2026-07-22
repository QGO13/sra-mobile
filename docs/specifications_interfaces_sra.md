# Spécifications Visuelles, Ergonomiques et Fonctionnelles des Interfaces — SRA Hôtel

Ce document fournit une vue d'ensemble exhaustive du projet **SRA Hôtel (Sweet Rest Aparthotel)**. Il détaille l'identité de marque, les directives ergonomiques et la charte graphique (dérivées de la charte officielle et du design system), ainsi qu'une description fonctionnelle et visuelle de l'ensemble des écrans et pages de l'écosystème applicatif (parcours client, gestion opérationnelle terrain et administration back-office).

---

## 1. Présentation Générale du Projet

**SRA Hôtel** est une solution moderne de gestion hôtelière (PMS - Property Management System) et de services clients intégrée au sein d'une application mobile et tablette adaptative. L'application répond à un double objectif :
1. **Offrir une expérience client premium** en autonomie complète (recherche, réservation multi-chambres avec évitement du surbooking, configuration de suppléments, facturation normalisée et paiement mobile/carte).
2. **Optimiser la gestion opérationnelle de l'établissement** en connectant en temps réel les différents acteurs (réceptionnistes, gouvernantes, femmes de ménage, personnel de cuisine, administrateurs et direction).

---

## 2. Charte Graphique & Identité Visuelle

L'application incarne un **luxe discret**, alliant classicisme et modernité technologique. Les interfaces doivent respecter scrupuleusement les choix chromatiques et typographiques établis pour refléter le standing haut de gamme de l'établissement.

### 2.1 Palette Chromatique & Contraste

La palette s'articule autour du contraste profond entre des fonds sombres/crème raffinés et des reflets dorés prestigieux.

*   **Or Prestige (Dégradé d'accentuation) :** `#D4AF37` à `#AA7C11` (avec nuances secondaires en champagne gold `#C5985B` et bronze satiné `#8C6221`). Utilisé pour les logos, les boutons d'action principaux (CTA), les puces actives, les prix et les indicateurs premium.
*   **Anthracite Profond (Fonds de contraste & Textes) :** `#1A1A1A` (nuance adoucie `#242322`). Utilisé pour les arrière-plans en mode sombre, les cartes contrastées et les textes de titres principaux.
*   **Crème & Blanc Cassé (Surfaces & Clarté) :** `#FAF8F5` / `#F7F5F1`. Utilisé comme couleur de fond principale (mode clair) pour laisser respirer l'interface.
*   **Blanc Pur :** `#FFFFFF`. Utilisé pour les surfaces de cartes épurées se superposant sur le fond crème.
*   **Gris Doux :** `#EDE9E2`. Utilisé pour les bordures fines de 1px afin d'isoler élégamment les éléments sans surcharger le design.

### 2.2 Typographie

Le système typographique combine l'élégance historique et la rigueur fonctionnelle mobile.

*   **Titres & Numéros (Primaire) :** `Cormorant Garamond` (ou `Playfair Display`). Une police Serif (à empattements) fine et proportionnée, traduisant le prestige et la tradition de l'hôtellerie de luxe.
*   **Corps de texte & UI (Secondaire) :** `Montserrat` (ou `Raleway`/`Lato`). Une police Sans-Serif (géométrique et moderne), garantissant une lisibilité maximale pour les fiches techniques, les formulaires de saisie et les libellés de l'application sur toutes les tailles d'écrans.

### 2.3 Formes, Angles et Ombres

*   **Bordures (Border Radius) :**
    *   `10px` (`radius-sm`) : Champs de saisie (Inputs).
    *   `18px` (`radius-md`) : Cartes secondaires ou de taille moyenne (articles du panier, boutons de filtres).
    *   `24px` à `28px` (`radius-lg` / `radius-xl`) : Grandes cartes de contenu, sections et grands conteneurs.
    *   `999px` (`radius-pill`) : Boutons en forme de pilules et puces ("chips") de filtres.
*   **Jeux d'Ombres (Box Shadows) :**
    *   *Ombre de carte classique :* Légère et diffuse pour détacher les cartes blanches du fond crème (`0 14px 34px -18px rgba(26, 26, 26, 0.35)`).
    *   *Ombre douce :* Plus étendue pour les zones survolées ou les fenêtres modales (`0 20px 50px -20px rgba(26, 26, 26, 0.25)`).
    *   *Ombre dorée incandescente :* Réservée aux boutons principaux dorés pour créer un effet de halo lumineux haut de gamme (`0 10px 24px -8px rgba(170, 124, 17, 0.55)`).

---

## 3. Directives Ergonomiques & Expérience Utilisateur (UX)

L'ergonomie de l'application repose sur la simplicité d'utilisation, l'accessibilité universelle et la fluidité des parcours métiers.

### 3.1 Design Adaptatif (Responsive) et Mobile-First

L'application s'adapte dynamiquement à la taille de l'écran de l'utilisateur :
*   **Smartphone (Compact, < 600px) :** Navigation optimisée à une main via une barre inférieure (`BottomNavigationBar`). Affichage vertical mono-colonne pour les formulaires et les listes.
*   **Tablette (Medium, 600px - 1024px) :** Structure hybride en grille (2 colonnes pour les chambres ou les formulaires) avec l'intégration de panneaux latéraux rétractables.
*   **Bureau / Grande Tablette (Expanded, >= 1024px) :** Navigation persistante latérale (`NavigationRail` ou sidebar fixe). Les formulaires complexes sont limités à une largeur maximale de `500px` et centrés à l'écran pour éviter la fatigue visuelle.

### 3.2 Gestion Rigoureuse des États (Erreurs & Listes Vides)

*   **Aucun message d'erreur brut** (comme des exceptions SQL ou réseau) ne doit être visible. L'interface utilise un composant unifié `ErrorStateView` qui propose un message traduit vulgarisé et un bouton "Réessayer" (`onRetry`) connecté à la source de données.
*   **Aucun écran vierge** en l'absence de données. L'application intègre systématiquement un composant `EmptyStateView` affichant une illustration filaire dorée, un titre chaleureux, un texte d'explication et un bouton d'action contextuel (ex: "Lancer une recherche", "Ajouter un élément").
*   **Indicateurs de chargement :** Les transitions d'états sont accompagnées de squelettes animés (Shimmers) ou d'un indicateur de chargement rotatif propre (`LoadingIndicator`) reprenant le logo stylisé.

### 3.3 Internationalisation Globale (l10n)

Chaque texte, bouton ou alerte est localisé dynamiquement dans les **6 langues officielles** de l'établissement :
*   **Français** (Langue par défaut)
*   **Anglais** (Standard international)
*   **Espagnol** (Prise en compte des accents natifs)
*   **Allemand** (Prise en compte des umlauts et des mots longs)
*   **Arabe** (Support complet du sens d'écriture Droite-à-Gauche - RTL)
*   **Chinois** (Support des caractères idéographiques compacts)

---

## 4. Description Détaillée des Pages de l'Application

Les sections suivantes détaillent le contenu et le rôle de l'ensemble des pages de l'écosystème SRA Hôtel, regroupées par univers fonctionnels.

### 4.1 Module d'Authentification & Gestion de Compte

#### Page de Connexion (Login)
*   **Description :** Interface d'entrée sécurisée permettant aux clients et aux collaborateurs de s'authentifier.
*   **Contenu et Éléments Visuels :**
    *   Logo de l'hôtel centré en haut avec son monogramme "SR".
    *   Formulaire d'authentification épuré (champs E-mail et Mot de passe avec icônes de contrôle de visibilité).
    *   Bannière d'accès rapide pour les comptes de démonstration (`DemoAccountsBanner`) permettant de pré-remplir les profils de test (Client, Admin, Réceptionniste, Gouvernante, Femme de ménage).
    *   Lien discret "Mot de passe oublié ?" en bronze satiné.
    *   Bouton de connexion doré de type pilule.
    *   Bouton d'inscription redirigeant vers la création de compte.

#### Page d'Inscription (Register)
*   **Description :** Permet la création de comptes pour trois typologies de clients distinctes.
*   **Contenu et Éléments Visuels :**
    *   Sélecteur d'onglets (Tabbar) stylisé en Or Champagne pour choisir le profil de compte :
        1. **Particulier :** Champs Nom, Prénom, E-mail, Téléphone, Sexe, Pays d'origine, Adresse physique, Mot de passe.
        2. **Corporate (Entreprise) :** Raison sociale, Numéro IFU, Adresse de l'entreprise, Nom du représentant, E-mail d'entreprise, Téléphone professionnel.
        3. **Agence :** Nom de l'agence, Identifiant d'accréditation touristique, E-mail, Téléphone, Adresse.
    *   Bouton de validation de type pilule avec effet d'élévation dorée.

#### Page de Profil Client
*   **Description :** Espace personnel permettant au client de consulter et mettre à jour ses informations et de configurer son profil.
*   **Contenu et Éléments Visuels :**
    *   En-tête premium avec avatar du client et affichage de son rôle / niveau de fidélité (ex: Client Club Prestige).
    *   Blocs de détails personnels éditables (Coordonnées, IFU fiscale pour les professionnels).
    *   Historique d'activité et raccourci vers les paramètres de langue de l'application.
    *   Option de déconnexion sécurisée.

---

### 4.2 Module Réservations Clients (B2C)

#### Coquille Client (Client Shell)
*   **Description :** Cadre de navigation adaptatif structurant l'expérience utilisateur client.
*   **Contenu et Éléments Visuels :**
    *   *Sur smartphone :* Barre de navigation inférieure (`BottomNavigationBar`) contenant des liens vers l'Accueil, les Réservations, le Panier et le Profil.
    *   *Sur tablette/PC :* Barre de navigation latérale (`NavigationRail`) laissant une large place au contenu central.
    *   Bouton flottant pour afficher le panier avec un badge réactif indiquant le nombre d'articles réservés.

#### Page d'Accueil Client (Home)
*   **Description :** Tableau de bord du client connecté affichant un récapitulatif de son statut et des accès rapides.
*   **Contenu et Éléments Visuels :**
    *   Message de bienvenue personnalisé lisant dynamiquement le nom du client.
    *   Raccourci visuel proéminent : une grande bannière élégante invitant à "Réserver un séjour" avec le dégradé doré signature.
    *   Aperçu rapide de la prochaine réservation active (si disponible).
    *   Liens directs vers les services phares de l'hôtel (Room Service, Spa, Concierge).

#### Page de Sélection et Réservation de Chambres (Client Booking)
*   **Description :** Parcours de réservation guidé et anti-overbooking permettant de rechercher et d'ajouter des chambres.
*   **Contenu et Éléments Visuels :**
    *   **Étape 1 - Choix de la typologie :** Grille des catégories de chambres (Standard, Premium, Suite) avec de magnifiques visuels d'illustration, tarifs de base, capacité maximale d'accueil et description des équipements.
    *   **Étape 2 - Choix des dates :** Sélecteurs ergonomiques de dates d'arrivée (check-in) et de départ (check-out).
    *   **Étape 3 - Disponibilité et Alternatives :**
        *   *Si la catégorie choisie est disponible :* Sélecteur de quantité de chambres à réserver (limité par le stock libre réel).
        *   *Si la catégorie est épuisée :* Présentation d'offres alternatives immédiates (ex: "La catégorie Standard est complète, nous vous suggérons la catégorie Premium pour +15 000 FCFA").
    *   Une alerte ergonomique apparaît automatiquement si des enfants sont saisis pour suggérer des typologies de grande capacité (Suites).

#### Page du Panier d'Achat (Cart)
*   **Description :** Liste des chambres sélectionnées et configuration des options de séjour avant paiement.
*   **Contenu et Éléments Visuels :**
    *   Liste de cartes de chambres réservées sous forme de tuiles épurées.
    *   Options à bascule (Pills or/crème) configurables par chambre :
        *   **Petit-déjeuner :** Possibilité d'activer ou désactiver, avec curseur pour configurer la quantité de bénéficiaires (+5 000 FCFA par personne et par nuit).
        *   **Lit d'appoint :** Option bridée et visible **uniquement** pour les Suites (inaccessible pour Standard/Premium).
    *   Récapitulatif financier réactif en bas de page : calcul du montant hors taxes (HT), des suppléments (lits, déjeuners) et du sous-total.
    *   Bouton d'engagement vers le paiement : "Procéder à la facturation".

#### Page de Pré-facturation et de Paiement (Checkout & PreInvoice)
*   **Description :** Écran de facturation normalisée et passerelle de paiement intégrée.
*   **Contenu et Éléments Visuels :**
    *   **Facture Normalisée DGI :** Présentation sous forme de ticket financier traditionnel avec des lignes en pointillés, affichage clair des taxes réglementaires de Côte d'Ivoire (TVA 18%, TST 2.5%, Taxe de séjour de 500 FCFA par nuit).
    *   Affichage des mentions de contrôle obligatoires (numéro de facture DGI, code de sécurité, hash de contrôle) une fois le paiement finalisé.
    *   **Panneau de Paiement (BottomSheet) :**
        *   Sélecteur d'opérateurs avec logos natifs : MTN Money, Moov Money, Orange Money, Wave ou Carte Bancaire.
        *   Saisie du numéro de téléphone avec préfixe international automatique.
        *   Indicateur de progression d'attente de validation PIN (USSD / push OTP) ou bouton de redirection externe sécurisé pour la saisie de carte bancaire.

#### Page de Liste des Réservations Client
*   **Description :** Permet au client de consulter l'ensemble de ses séjours passés, en cours et à venir.
*   **Contenu et Éléments Visuels :**
    *   Sélecteur d'onglets pour filtrer les séjours (À venir, Terminés, Annulés).
    *   Cartes de réservation contenant la référence du séjour, les dates, le type de chambre attribuée et un badge coloré indiquant le statut (ex: Vert pour Payé, Gris pour En attente).

#### Page de Détail d'une Réservation
*   **Description :** Fiche complète d'un séjour réservé contenant toutes les instructions pratiques.
*   **Contenu et Éléments Visuels :**
    *   Rappel des dates d'arrivée et de départ avec compteur de jours restants (compte à rebours).
    *   Code QR de check-in rapide permettant au réceptionniste de scanner le mobile à l'arrivée.
    *   Détails de la facture réglée avec possibilité de télécharger le justificatif normalisé au format PDF.

#### Assistant Concierge IA "Sweetie"
*   **Description :** Chatbot conversationnel intelligent destiné à accompagner les résidents durant leur séjour.
*   **Contenu et Éléments Visuels :**
    *   Interface de chat moderne de style bulle avec contrastes crème et or.
    *   Suggestions de requêtes rapides en bulles flottantes (ex: "Quel est le mot de passe Wi-Fi ?", "Demander des serviettes", "Réserver une table").
    *   Statut en ligne de l'assistant avec icône d'IA pétillante.

#### Interface de Commandes Vocales
*   **Description :** Commande simplifiée et mains-libres des services de l'hôtel.
*   **Contenu et Éléments Visuels :**
    *   Grand bouton central en forme de micro avec animation d'ondes sonores dorées lors de la détection de la voix.
    *   Transcription écrite en temps réel de la commande vocale dictée.
    *   Retour visuel de confirmation (ex: "Commande enregistrée : 2 Cafés envoyés en chambre 104").

#### Page de Fidélisation (La Roue de la Fortune)
*   **Description :** Jeu interactif de gamification destiné à fidéliser les clients en leur permettant de remporter des avantages.
*   **Contenu et Éléments Visuels :**
    *   Roue chromatique dorée et bronze animée avec aiguille de tirage.
    *   Bouton central d'activation "Lancer la roue".
    *   Bannières d'affichage des récompenses (ex: "Petit-déjeuner offert", "Remise de 10% sur le Spa").

---

### 4.3 Module Opérations Terrain & Temps Réel (B2E Staff)

#### Page Gouvernance - Smartphone Femme de ménage
*   **Description :** Liste des chambres assignées pour la journée et mise à jour de leur état de propreté.
*   **Contenu et Éléments Visuels :**
    *   Liste compacte des chambres à nettoyer triée par priorité (départs urgents en premier).
    *   Boutons d'action rapide à glissement (Swipe actions) ou bascules simples pour changer l'état d'une chambre : *À nettoyer* (Rouge) ➔ *En cours* (Orange) ➔ *Propre* (Vert).
    *   Indicateur visuel si la chambre est occupée ou si le client a demandé le signal "Ne pas déranger".

#### Page Gouvernance - Tablette Gouvernante
*   **Description :** Console de supervision de l'état des étages pour la gouvernante générale.
*   **Contenu et Éléments Visuels :**
    *   Grille globale de l'hôtel affichant l'état sanitaire de chaque chambre en temps réel.
    *   Formulaire d'affectation des tâches permettant de glisser-déposer une liste de chambres sur le profil d'une femme de ménage.
    *   Bouton de validation finale d'état : passage de la chambre de *Nettoyé* à *Confirmé* (Prêt à la vente).
    *   Alertes visuelles instantanées en cas de litige ou de problème signalé (ex: ampoule grillée, fuite d'eau).

#### Page de Prise de Commandes Cuisine & Room Service
*   **Description :** Menu numérique interactif pour la saisie des commandes de restauration.
*   **Contenu et Éléments Visuels :**
    *   Catalogue de plats et boissons classés par catégories (Entrées, Plats, Desserts, Boissons).
    *   Choix obligatoire et proéminent du lieu de consommation sous forme de gros boutons illustrés : *Sur place*, *En chambre* (avec sélection du numéro de chambre active), ou *En livraison*.
    *   Bouton de transmission instantanée à la cuisine.

#### Page d'Écran Cuisine (Temps Réel)
*   **Description :** Interface installée en cuisine sur tablette ou écran mural pour le suivi des plats à préparer.
*   **Contenu et Éléments Visuels :**
    *   Tableau Kanban à 3 colonnes : *À préparer* (Commandes reçues), *En cours de cuisson*, *Prêt à servir*.
    *   Cartes de commandes affichant l'heure de réception, le temps écoulé (avec alerte rouge si retard), le détail des plats et les commentaires spécifiques (ex: "Sans sel", "Allergie arachide").
    *   Boutons tactiles géants pour valider la transition d'un état à l'autre d'un simple toucher.

#### Terminal d'Imputation sur Chambre (Restaurant / Bar)
*   **Description :** Outil de facturation rapide permettant de transférer une note de consommation sur le compte global d'un résident.
*   **Contenu et Éléments Visuels :**
    *   Pavé numérique de saisie rapide du numéro de chambre.
    *   Aperçu du nom du client principal pour validation d'identité.
    *   Récapitulatif de la note du bar/restaurant à imputer.
    *   Bouton de confirmation de transfert sur folio ("Mettre sur la chambre") nécessitant la signature tactile du client sur l'écran ou la validation par code PIN de sécurité du serveur.

---

### 4.4 Module Back-Office & Administration (Admin & Réception)

#### Tableau de Bord Réceptionniste (Reception Dashboard)
*   **Description :** Console principale pour la gestion des mouvements quotidiens de clientèle.
*   **Contenu et Éléments Visuels :**
    *   Résumé statistique du jour : nombre d'arrivées attendues (check-ins), départs prévus (check-outs) et chambres libres.
    *   Flux d'accès rapide pour effectuer un enregistrement (saisie du code QR client ou recherche de nom).
    *   Module de gestion des clés physiques ou électroniques des chambres.

#### Tableau de Bord d'Administration (Admin Dashboard)
*   **Description :** Centre de pilotage global pour les gérants de l'établissement, donnant accès à tous les modules de contrôle.
*   **Contenu et Éléments Visuels :**
    *   Menu en grille d'icônes filaires dorées permettant d'accéder aux différents sous-modules (Chambres, Utilisateurs, Tarifs, Services, Factures).
    *   Aperçu rapide des alertes système en cours (conflit de réservation, problème de synchronisation réseau).
    *   Bouton de navigation rapide vers les statistiques financières de l'hôtel.

#### Page de Visio Planning et Affectation des Chambres (Room Assignment)
*   **Description :** Outil visuel de gestion du calendrier d'occupation et d'attribution des chambres.
*   **Contenu et Éléments Visuels :**
    *   Quatre onglets d'affichage :
        1. **Visio Planning (Gantt) :** Grille temporelle affichant les chambres en lignes et les jours du mois en colonnes. Les séjours sont matérialisés par des blocs horizontaux colorés étirables. Le panneau de gauche affichant les numéros de chambres reste fixe lors du défilement.
        2. **Kanban :** Tableau d'organisation classant les séjours en colonnes selon leur statut (En attente, Confirmé, En séjour, Terminé, Annulé).
        3. **Calendrier :** Vue mensuelle globale indiquant le taux de remplissage quotidien et listant les mouvements sous le calendrier.
        4. **Liste :** Tableau de données complet avec barre de recherche rapide et filtres avancés.
    *   Fenêtre modale d'attribution/édition de chambre intégrant une vérification anti-overbooking en temps réel (excluant automatiquement les chambres occupées sur la période choisie).

#### Page de Gestion des Chambres (Admin Rooms)
*   **Description :** Permet à l'administrateur d'ajouter, modifier ou désactiver des chambres physiques du parc hôtelier.
*   **Contenu et Éléments Visuels :**
    *   Liste des chambres avec indication de leur numéro, étage, catégorie de prix et statut d'activation.
    *   Bouton "+" flottant pour ouvrir le formulaire de création d'une nouvelle chambre.
    *   Formulaire d'édition avec listes déroulantes de typologies et d'équipements associés.

#### Page de Gestion des Typologies de Chambres (Room Types)
*   **Description :** Configuration des caractéristiques des catégories de chambres proposées par l'établissement.
*   **Contenu et Éléments Visuels :**
    *   Liste des catégories (Standard, Premium, Suite, etc.).
    *   Champs de saisie du tarif de base par nuitée, de la capacité d'accueil (adultes et enfants maximum autorisés) et gestion de la galerie photo d'illustration.

#### Page de Gestion des Équipements (Admin Equipments)
*   **Description :** Inventaire et gestion des équipements présents dans les chambres (Wi-Fi, TV, Climatisation, Mini-bar, Jacuzzi).
*   **Contenu et Éléments Visuels :**
    *   Liste des équipements existants avec icônes associées.
    *   Formulaire d'ajout rapide d'un équipement et possibilité de le lier en masse à une typologie ou à une chambre spécifique.

#### Page de Gestion des Services et Suppléments (Admin Services)
*   **Description :** Configuration des prestations optionnelles vendues en supplément des nuitées.
*   **Contenu et Éléments Visuels :**
    *   Liste des suppléments (Petit-déjeuner, Lit d'appoint, Navette aéroport, Accès Spa).
    *   Configuration du type de facturation : tarif fixe par séjour, tarif par nuit, ou tarif par personne et par nuit.
    *   Indicateur d'activation du service sur le parcours client.

#### Page de Gestion des Utilisateurs et Collaborateurs (Admin Users)
*   **Description :** Liste et gestion des droits d'accès des employés et clients enregistrés.
*   **Contenu et Éléments Visuels :**
    *   Tableau récapitulatif triable par rôle (Admin, Réceptionniste, Gouvernante, Femme de ménage, Client).
    *   Formulaire d'attribution de rôle et de modification des informations de profil.
    *   Bouton de réinitialisation de mot de passe ou de désactivation de compte.

#### Page de Visualisation des Factures (Admin Invoices)
*   **Description :** Journal de facturation historique pour la vérification fiscale et financière.
*   **Contenu et Éléments Visuels :**
    *   Liste chronologique de toutes les factures normalisées DGI émises.
    *   Barre de recherche par numéro de facture, nom de client ou période fiscale.
    *   Indicateur de statut de paiement (Payé, Impayé, Avoir émis).
    *   Bouton de téléchargement ou d'impression directe de la facture fiscale.

#### Journaux Comptables ERP
*   **Description :** Journaux automatisés répertoriant les écritures de ventes et d'achats.
*   **Contenu et Éléments Visuels :**
    *   Tableaux structurés affichant les transactions débit/crédit classées par comptes comptables hôteliers.
    *   Filtres de dates pour les clôtures de caisse journalières, hebdomadaires ou mensuelles.
    *   Exportation de fichiers de comptabilité dans les formats d'intégration standards.

#### Inventaire Intelligent (Cuisine & Stocks)
*   **Description :** Outil d'alerte et de suivi des ingrédients et matières premières en temps réel.
*   **Contenu et Éléments Visuels :**
    *   Liste des stocks d'ingrédients clés avec jauge de volume colorée (Vert = Suffisant, Orange = Seuil critique approché, Rouge = Alerte rupture).
    *   Notification d'alerte automatique de réapprovisionnement liée aux ventes réalisées par le Room Service.

#### Tableau de Bord de Direction & Indicateurs KPIs
*   **Description :** Synthèse graphique de la santé financière et commerciale de l'établissement pour la direction.
*   **Contenu et Éléments Visuels :**
    *   Graphiques analytiques modernes affichant les indicateurs fondamentaux :
        *   **RevPAR** (Revenue Per Available Room / Revenu par chambre disponible).
        *   **Taux d'occupation** global en pourcentage.
        *   **Chiffre d'affaires journalier** ventilé par source (hébergement, restauration, spa).
    *   Comparatifs de performances par rapport au mois ou à l'année précédente sous forme de jauges et de flèches de tendance vertes/rouges.
