# Guide de l'Architecture et Conventions de Codage SRA-Hôtel

Ce document détaille les conventions architecturales et graphiques à respecter par l'ensemble des développeurs travaillant sur le front-end mobile.

---

## 1. Clean Architecture + Pattern BLoC + Features Modulaires

L'application est structurée de manière hautement modulaire selon les principes de la **Clean Architecture** couplés au framework de gestion d'état **BLoC** (Business Logic Component). 

Plutôt que d'avoir de gros modules fourre-tout, chaque concept métier doit être isolé sous sa propre micro-fonctionnalité (feature) dans `lib/features/[feature_name]/` :

- **`auth`** : Gestion exclusive de la session utilisateur, connexion (Login) et inscription (Register).
- **`home`** : Espace d'atterrissage et d'affichage du profil utilisateur.
- **`room_search`** : Recherche de disponibilités de chambres et vérification de statut en temps réel.
- **`cart`** : Gestion du panier d'achats de chambres et d'options (petit-déjeuner, lit d'appoint).
- **`checkout`** : Établissement de la pré-facture normalisée (calcul TVA, TST, taxe de séjour) et traitement de paiement FedaPay.

Chaque fonctionnalité est découpée en 3 couches distinctes :

```
lib/features/[feature_name]/
├── data/                  # Couche de données (Dépôts, Sources de données, Modèles)
│   ├── datasources/       # Appel API (remote) et Local SQLite (local)
│   ├── models/            # DTOs et parsing JSON (UserModel, RoomModel, etc.)
│   └── repositories/      # Implémentations concrètes des contrats de dépôts
├── domain/                # Couche métier pure (sans dépendance externe ni framework)
│   ├── entities/          # Objets métiers purs (UserEntity, RoomEntity)
│   ├── repositories/      # Contrats / interfaces abstraites des dépôts
│   └── usecases/          # Cas d'utilisation uniques (LoginUseCase, SearchRoomsUseCase)
└── presentation/          # Couche d'interface utilisateur (UI)
    ├── bloc/              # State management (bloc, state, event)
    ├── pages/             # Conteneurs de pages (structures de mise en page)
    └── widgets/           # Widgets spécifiques à la fonctionnalité
```

### Règles d'or :
- **Entités vs Modèles :** Les entités dans `domain` doivent être des classes de données pures. Les conversions JSON (`fromJson`, `toJson`) doivent être cantonnées aux modèles dans `data/models/` qui étendent ces entités.
- **Dossier UseCases :** Un cas d'utilisation (UseCase) ne doit faire qu'une seule et unique chose métier (ex: recherche de chambres).
- **Indépendance de la couche Domain :** La couche `domain` ne doit importer aucun package externe (sauf cas exceptionnel comme `equatable`). Elle ne doit jamais faire référence à Flutter, Dio ou SQLite.

---

## 2. Règle Stricte : Zéro Widget Inline dans les Pages

Afin d'assurer la cohérence visuelle, la maintenabilité et de maximiser la réutilisation du code, **aucun widget graphique personnalisé ne doit être déclaré directement dans le fichier d'une page**.

### Directive :
- **Pages de mise en page (`features/presentation/pages/`) :** Les pages ne servent que de structures d'organisation (ex: Scaffold, AppBar, Column/Row de mise en page générale). Elles assemblent des blocs et appellent des widgets externes.
- **Widgets partagés globaux (`core/widgets/`) :** Les boutons (`SraButton`), les logos (`SraLogo`), les indicateurs de chargement (`LoadingIndicator`), les inputs (`SraInput`) et la bannière déroulante (`DemoAccountsBanner`) appartiennent au Core et sont importés.
- **Widgets spécifiques à une feature (`presentation/widgets/`) :** Si un widget visuel est réutilisé ou complexe (ex: une carte de chambre `RoomCard` ou un composant de panier `CartItemCard`), il doit être isolé dans le sous-dossier `widgets` de la fonctionnalité concernée.

---

## 3. Injection de Dépendances (DI) avec GetIt

Le projet utilise le conteneur de services [injection_container.dart](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/injection_container.dart). Toute classe implémentant un service, un dépôt, une source de données ou un BLoC doit y être déclarée.

### Utilisation :
1. Déclarer la feature dans `init()` de [injection_container.dart](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/injection_container.dart) :
   - Les **BLoCs** sont enregistrés avec `registerFactory` (un BLoC possède un cycle de vie lié au widget et doit être fermé/re-créé).
   - Les **UseCases, Repositories et DataSources** sont enregistrés avec `registerLazySingleton` (une seule instance globale instanciée à la demande).
2. Pour récupérer une instance dans le code :
   ```dart
   final authBloc = di.sl<AuthBloc>();
   ```

---

## 4. Charte Graphique, Thèmes et Polices Premium (Web-Aligned)

Les couleurs et typographies officielles de la charte de SRA-Hôtel sont configurées dans [app_theme.dart](file:///d:/SRA-HOTEL/SRA-Projet/frontend-mobile/lib/core/theme/app_theme.dart) :
- **Gold Champagne (Or Accent) :** `Color(0xFFC5985B)` — Accent de prestige, boutons actifs, labels majuscules.
- **Ink (Noir Encre) :** `Color(0xFF212222)` — Couleur principale du texte et fond de l'application en mode sombre.
- **Fog (Brouillard / Fond clair) :** `Color(0xFFF7F5F1)` — Arrière-plan général en mode clair.
- **Mist (Brume / Bordures) :** `Color(0xFFEDE9E2)` — Bordures fines de 1px pour les cartes, inputs et séparations (design flat luxury).

### Typographies :
- **Style Serif (Titres, Numéros) :** `Playfair Display` via `GoogleFonts`
- **Style Sans-Serif (Textes, Boutons) :** `Raleway` via `GoogleFonts`

### Règle d'usage :
Ne jamais coder de couleurs ou de styles de texte en dur dans vos widgets. Utilisez toujours le thème système via le contexte :
```dart
color: Theme.of(context).colorScheme.primary
```
Pour les couleurs spécifiques de la marque SRA, utilisez les constantes configurées dans `AppColors` :
```dart
color: AppColors.champagneGold
```

---

## 5. Règle : Design Premium Responsive & Adaptatif

Pour garantir une expérience de prestige sur tous les types d'écrans (Mobiles, Tablettes et Navigateurs de bureau / Web), l'interface doit s'adapter dynamiquement à la largeur disponible.

### Points de rupture (Breakpoints) :
- **Mobile (Compact) :** Largeur `< 600` pixels. Layout vertical mono-colonne.
- **Tablette (Medium) :** Largeur `>= 600` et `< 1024` pixels. Grid layout à 2 colonnes ou panneaux latéraux ajustés.
- **Bureau / Web (Expanded) :** Largeur `>= 1024` pixels. Organisation multi-colonnes complexe (ex: panneau de filtres à gauche, résultats sous forme de grille à droite).

### Directives d'implémentation :
- **LayoutBuilder & OrientationBuilder :** À privilégier pour adapter le nombre de colonnes d'une grille ou inverser une Row en Column.
- **Contraintes de largeur max (Centrage) :** Pour les formulaires (ex: Login, Inscription), la largeur doit être contrainte (max `500` pixels) et centrée sur grand écran pour éviter l'étirement inesthétique.
- **Navigation adaptative :** Sur grand écran, privilégier des panneaux latéraux (`NavigationRail`) ou un menu persistant au lieu du tiroir (`Drawer`) mobile.

---

## 6. Règle : Documentation Individuelle par Module

Afin d'assurer le suivi, l'explication technique et la clarté fonctionnelle de chaque module développé, **chaque module implémenté doit faire l'objet d'un fichier de documentation Dedicated Markdown dans le répertoire `docs/`**.

### Directive :
- Le fichier doit être nommé selon la fonctionnalité concernée (ex: `docs/auth_module.md` pour le module d'authentification et profil, `docs/booking_module.md` pour les modules de recherche et de panier, ou `docs/payment_module.md` pour le module de paiement/checkout).
- Ce fichier doit spécifier :
  1. Les fonctionnalités implémentées.
  2. L'architecture technique (BLoCs, Usecases, data sources).
  3. Les règles fiscales et de calcul applicables (ex: taux de TVA, taxe de séjour, TST).
  4. Les scénarios de tests unitaires et d'intégration validés.

---

## 7. Règle : Traduction et Localisation Complète (l10n)

Pour garantir une expérience multilingue propre (Français et Anglais), **aucun texte ou libellé ne doit être codé en dur directement dans les widgets ou pages de l'application**.

### Directive :
- **Utilisation systématique d'AppLocalizations :** Tous les textes affichés à l'écran doivent être extraits du contexte via `AppLocalizations.of(context)![key]`.
- **Renseignement après chaque module :** Après l'implémentation de chaque module, le développeur doit obligatoirement renseigner et traduire toutes les nouvelles chaînes de caractères dans les fichiers de localisation (`lib/l10n/app_fr.arb` et `lib/l10n/app_en.arb`) avant la validation du module.

---

## 8. Règle : Gestion Unifiée des États (Erreurs & Listes Vides)

Pour préserver l'image de prestige de SRA Hôtel, **aucun message d'erreur brut (DioException, Exception, erreurs SQL/BD) ne doit être affiché directement à l'utilisateur**. De plus, les listes vides ne doivent jamais donner lieu à un écran blanc sans message.

### Directive :
- **Widgets Standardisés (Obligatoire) :** Toute page ou section de l'application qui gère un état d'erreur ou un état vide doit utiliser les widgets partagés du Core :
  - `ErrorStateView` (dans `lib/core/widgets/error_state_view.dart`) : pour afficher des erreurs catégorisées de connexion, de serveur ou inattendues, accompagnées d'un bouton "RÉESSAYER" relié au BLoC.
  - `EmptyStateView` (dans `lib/core/widgets/empty_state_view.dart`) : pour afficher des listes ou rubriques vides avec une icône dorée stylisée, un titre, un sous-titre localisé et un bouton d'action optionnel (plein ou entouré).
- **Zéro Code Dupliqué :** Il est strictement interdit de créer des mises en page d'erreur ou d'état vide personnalisées (ex: colonnes customisées, icônes brutes, textes inline) à l'intérieur des pages de fonctionnalités.
- **Utilisation d'ErrorMapper :** L'analyse des exceptions doit se faire via la classe utilitaire `ErrorMapper` (dans `lib/core/error/error_handler.dart`) qui extrait automatiquement le type d'erreur pour présenter des messages localisés, clairs et rassurants.
