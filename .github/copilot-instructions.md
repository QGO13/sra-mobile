# SRA Hôtel Mobile — Directives Agents (Antigravity)

Ce fichier est lu automatiquement par Antigravity à chaque interaction. Il contient **l'ensemble des règles non-négociables** du projet. Tout code généré doit s'y conformer strictement et sans exception.

> **Référence Docs** : [`docs/architecture_conventions.md`](../docs/architecture_conventions.md) · [`docs/localization_conventions.md`](../docs/localization_conventions.md) · [`docs/auth_module.md`](../docs/auth_module.md) · [`docs/booking_module.md`](../docs/booking_module.md) · [`docs/payment_module.md`](../docs/payment_module.md)

---

## 1. 🏗️ Clean Architecture Modulaire (Obligatoire)

Chaque fonctionnalité (feature) doit être implémentée dans son propre module isolé sous `lib/features/[feature_name]/`, découpé en **trois couches strictes** :

```
lib/features/[feature_name]/
├── data/
│   ├── datasources/        # remote_datasource.dart, local_datasource.dart
│   ├── models/             # [entity]_model.dart (extends Entity + fromJson/toJson)
│   └── repositories/       # Implémentation concrète du contrat domain
├── domain/
│   ├── entities/           # Objets métiers purs (sans dépendance Flutter/Dio/SQLite)
│   ├── repositories/       # Contrats abstraits (abstract class IXxxRepository)
│   └── usecases/           # Un fichier = un seul cas d'usage métier (ex: login_usecase.dart)
└── presentation/
    ├── bloc/               # xxx_bloc.dart, xxx_event.dart, xxx_state.dart
    ├── pages/              # Conteneurs de mise en page uniquement (pas de logique UI inline)
    └── widgets/            # Widgets spécifiques et réutilisables à cette feature
```

### Règles absolues :
- La couche `domain/` ne doit **jamais** importer Flutter, Dio, SQLite ou tout autre package externe (seul `equatable` est toléré).
- Un `UseCase` = une seule action métier. Nommer en verbe + complément : `LoginUseCase`, `SearchRoomsUseCase`, `CreateInvoiceUseCase`.
- Les **conversions JSON** (`fromJson`, `toJson`) sont **uniquement** dans les `models/` de la couche `data/`.
- Toute classe (BLoC, UseCase, Repository, DataSource) doit être **enregistrée** dans `lib/injection_container.dart` :
  - `registerFactory` → BLoC
  - `registerLazySingleton` → UseCase, Repository, DataSource

---

## 2. 📦 Gestion des Widgets (Zéro Widget Inline dans les Pages)

### Règle absolue :
**Aucun widget graphique personnalisé ne doit être déclaré directement dans un fichier de page.**

### Organisation :
- **`lib/core/widgets/`** — Widgets globaux partagés entre plusieurs modules :
  - `SraButton`, `SraInput`, `SraLogo`, `LoadingIndicator`, `DemoAccountsBanner`, `LanguageSelector`, etc.
- **`lib/features/[feature]/presentation/widgets/`** — Widgets propres à un seul module :
  - Ex: `RoomCard`, `CartItemCard`, `BookingStatusBadge`, `InvoiceLineItem`, etc.
- Les pages (`pages/`) ne font qu'**assembler** des widgets. Elles contiennent le `Scaffold`, la structure générale de mise en page, et les appels BLoC via `BlocBuilder` / `BlocListener`.

---

## 2b. 🔄 Gestion des États (Erreurs & Listes Vides)

### Règle absolue :
**Aucun message d'erreur brut (DioException, SQL, exception brute) ne doit être affiché directement à l'utilisateur. De même, les états vides ne doivent jamais donner lieu à un écran vierge.**

### Organisation :
- **`ErrorStateView`** (dans `lib/core/widgets/error_state_view.dart`) : doit être systématiquement utilisé en cas d'erreur avec un callback `onRetry` relié au BLoC pour rafraîchir les données.
- **`EmptyStateView`** (dans `lib/core/widgets/empty_state_view.dart`) : doit être systématiquement utilisé lorsque les listes de données chargées sont vides, en spécifiant au besoin une icône, un titre, un sous-titre localisé, et un bouton d'action.
- **`ErrorMapper`** (dans `lib/core/error/error_handler.dart`) : sert à analyser les messages d'erreur et à les traduire automatiquement en messages apaisants et clairs pour l'utilisateur.
- **Interdiction formelle** de créer des mises en page d'erreur ou d'état vide sur mesure dans les pages de fonctionnalités.

---

## 3. 🎨 Charte Graphique & Thème (Zéro Valeur Hardcodée)

### Couleurs — Utiliser uniquement `AppColors` (défini dans `lib/core/theme/app_theme.dart`) :
```dart
AppColors.champagneGold    // #C5985B — Accent prestige, boutons, labels
AppColors.imperialNightBlue // #212222 — Fond dark mode, texte principal
AppColors.fog              // #F7F5F1 — Fond light mode
AppColors.softGrey         // #EDE9E2 — Bordures fines 1px (design flat luxury)
AppColors.deepBlue         // Pour les surfaces secondaires dark
```

### Typographies — Jamais de FontFamily hardcodée dans les widgets :
- **Titres, Numéros** : `Playfair Display` via `GoogleFonts`
- **Textes, Boutons, Labels** : `Raleway` via `GoogleFonts`
- Toujours accéder via `Theme.of(context).textTheme` ou `AppTextStyles.*`

### Espacement et Dimensions :
- Utiliser les constantes définies dans `AppDimensions` (ex: `AppDimensions.paddingMd`, `AppDimensions.radiusSm`).
- **Jamais** de valeurs numériques brutes (`padding: EdgeInsets.all(16)`) dans les pages ou widgets. Utiliser les constantes du thème.

---

## 4. 📱 Design Responsive & Mobile-First

L'interface doit s'adapter dynamiquement à toutes les tailles d'écran. La stratégie est **Mobile-First**.

### Breakpoints officiels :
| Taille | Largeur | Layout |
|--------|---------|--------|
| **Mobile (Compact)** | `< 600px` | Mono-colonne vertical · `BottomNavigationBar` |
| **Tablette (Medium)** | `>= 600px` et `< 1024px` | Grid 2 colonnes · Panneaux latéraux |
| **Bureau / Web (Expanded)** | `>= 1024px` | Multi-colonnes · `NavigationRail` / Sidebar persistante |

### Navigation adaptative — Règle obligatoire :
```dart
// Pattern à utiliser dans tous les shells de navigation :
Widget build(BuildContext context) {
  final isWide = MediaQuery.of(context).size.width >= 1024;
  return isWide
      ? _buildSidebarLayout()   // NavigationRail ou Drawer permanent
      : _buildBottomNavLayout(); // BottomNavigationBar standard
}
```

### Règles de mise en page :
- Utiliser `LayoutBuilder` et `MediaQuery` pour adapter le nombre de colonnes.
- Les formulaires (Login, Inscription, etc.) ont une largeur **max de 500px** et sont **centrés** sur grand écran.
- Les grilles de chambres/cartes utilisent `GridView` avec crossAxisCount adaptatif.

---

## 5. 🌐 Internationalisation (l10n) — Zéro Texte Hardcodé

> Référence complète : [`docs/localization_conventions.md`](../docs/localization_conventions.md)

### Langues supportées (toutes obligatoires à chaque nouvelle clé) :
| Fichier | Langue | Particularité |
|---------|--------|---------------|
| `app_fr.arb` | Français | Langue de référence |
| `app_en.arb` | Anglais | — |
| `app_es.arb` | Espagnol | Accents natifs (`é`, `ñ`, `ó`) |
| `app_de.arb` | Allemand | Umlauts (`ä`, `ö`, `ü`) |
| `app_ar.arb` | Arabe | Support RTL obligatoire |
| `app_zh.arb` | Chinois | Caractères idéographiques |

### Processus de travail l10n :
1. Ajouter la clé dans **les 6 fichiers `.arb` simultanément**.
2. Lancer `flutter gen-l10n`.
3. Lancer le script BOM : `dart scratch/add_bom.dart`
4. Utiliser dans les widgets : `AppLocalizations.of(context)!.maClé`

### Bug Windows (Encodage UTF-8 BOM) :
- Après chaque `flutter gen-l10n`, **toujours** ré-injecter le BOM pour éviter le décodage ANSI/Windows-1252.
- Script : `dart C:\Users\darag\.gemini\antigravity\brain\b7242d41-6b80-45ce-bba1-d4f3fd4dd35c\scratch\add_bom.dart`
- Aucune chaîne double-encodée (`Ã©`, `Ã´`, `Ã±`) n'est tolérée dans le code source.

---

## 6. 👥 Profils Utilisateurs & Contrôle d'Accès

L'application gère **5 profils** avec des accès distincts. Le routing et les menus doivent s'adapter dynamiquement au rôle de l'utilisateur connecté.

| Rôle | Périmètre |
|------|-----------|
| **Admin** | CRUD global : chambres, collaborateurs, types de chambres, services, KPIs, factures |
| **Réceptionniste** | Attribution chambres, Arrivées/Départs, Factures/Règlements, Statut chambres |
| **Gouvernante** | Dashboard nettoyage, affectation des femmes de ménage, statuts globaux |
| **Femme de ménage** | Liste de ses chambres à nettoyer, mise à jour statut (Propre / En cours) |
| **Client** | Recherche, réservation, historique, profil, services |

- Le shell de navigation (Back-Office / Front-Client) se construit **dynamiquement** à partir du rôle stocké dans l'entité `UserEntity`.
- Ne jamais hard-coder une page dans la navigation sans vérification du rôle.

---

## 7. ✅ Critères de Complétion d'un Module

Un module n'est considéré **officiellement terminé** que lorsque **tous les critères suivants sont validés** :

### Checklist de complétion :
```
[ ] Structure Clean Architecture complète et conforme (domain / data / presentation)
[ ] Enregistrement dans injection_container.dart
[ ] Zéro texte hardcodé — tous les libellés passent par AppLocalizations
[ ] Nouvelles clés l10n ajoutées dans les 6 fichiers .arb
[ ] flutter gen-l10n exécuté + BOM réinjecté
[ ] Widgets extraits dans core/widgets/ ou presentation/widgets/ (jamais inline dans les pages)
[ ] Design responsive vérifié (Mobile / Tablette / Web) avec navigation adaptative
[ ] Couleurs et dimensions via constantes du thème (AppColors, AppDimensions)
[ ] Tests unitaires écrits pour les UseCases et les BLoC
[ ] Tests de widget écrits pour les pages/widgets principaux
[ ] flutter analyze → 0 erreur, 0 warning
[ ] Fichier de documentation créé dans docs/[module_name].md
```

**Seul un module qui passe l'ensemble de cette checklist peut être marqué `[x]` dans `task.md`.**

---

## 8. 🧪 Tests (Obligatoires à la Complétion)

La structure de tests mirror l'arborescence des sources :

```
test/
├── features/
│   └── [feature_name]/
│       ├── domain/
│       │   └── usecases/        # Tests unitaires des UseCases
│       ├── data/
│       │   └── repositories/    # Tests des Repository avec mocks
│       └── presentation/
│           └── bloc/            # Tests BLoC (événements → états)
└── core/
    └── widgets/                 # Tests de Widget des composants Core
```

### Outils :
- `mocktail` ou `mockito` pour les mocks.
- `bloc_test` pour les tests BLoC.
- `flutter_test` pour les tests de widget.

---

## 9. 📝 Documentation par Module (Obligatoire)

Après l'implémentation de chaque module, créer ou mettre à jour un fichier Markdown dans `docs/` :
- `docs/[module_name]_module.md`
- Ce fichier doit décrire : fonctionnalités, architecture BLoC, UseCases, règles métier, et les scénarios de tests validés.

---

## 10. 🔄 Processus de Travail Agent (Workflow)

À chaque prompt de développement, Antigravity doit suivre ce processus :

1. **Lire** ce fichier (`AGENTS.md`) et les docs référencées avant d'écrire du code.
2. **Vérifier** la structure existante du module concerné avant de créer de nouveaux fichiers.
3. **Coder** en respectant toutes les règles ci-dessus.
4. **Ajouter** les clés l10n dans les 6 langues + regénérer + réinjecter BOM.
5. **Lancer** `flutter analyze` — Zéro erreur/warning obligatoire avant de clôturer.
6. **Mettre à jour** `task.md` avec le statut d'avancement.
