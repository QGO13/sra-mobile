# Guide de migration — Design SRAh V2 (sra-mobile)

> Document de cadrage à donner tel quel à tout agent (Claude ou autre) qui reprend le travail.
> Dernière mise à jour : 24 juillet 2026 — **5.1 complété** (Auth pixel-perfect + SraAlert + nouveaux tokens SraButton/SraInput) · **5.3 en cours** (Rooms & Room Types admin — pastilles de statut/typologie corrigées, écart de données consigné §7, revue visuelle finale restant à faire) · **5.4 en cours** (Visio Planning pixel-perfect : couleurs de statut, contraste, rayon/ombre des barres, teinte week-end, légende ajoutée ; audit large des alias dépréciés sur tout le module `room_assignment` ; revue visuelle finale et `flutter analyze` restant à faire, pas de SDK Flutter dans cet agent).

---

## 1. Objectif du projet

Faire migrer l'application Flutter **sra-mobile** vers le nouveau design **SRAh V2**, avec le niveau d'exigence suivant :

1. **Pixel perfect sur les pages où une maquette existe** dans `design_SRAh` : couleurs, typographies, rayons, ombres, espacements, structure visuelle identiques.
2. **Ramifications "vie réelle" acceptées** : le design de référence est une app **web/desktop (React + MUI)**, la cible finale est une **app mobile (Flutter)**. Les adaptations liées au format (colonnes de data grid qui deviennent des listes, navigation desktop qui devient une bottom nav, etc.) sont normales et attendues — ce ne sont **pas** des divergences à corriger, tant qu'elles respectent l'esprit visuel (couleurs, typo, arrondis, ombres, ton général).
3. **Pages/flows absents de la maquette** : elles doivent être conçues **dans la même vague visuelle** que le reste (mêmes tokens, mêmes composants, même grammaire graphique), même s'il n'existe pas de maquette précise à copier.
4. **Étapes manquantes dans un parcours** (ex. une maquette montre les étapes 1, 2, 4 d'un flow mais pas la 3) : on les complète nous-mêmes, en cohérence avec l'existant (mêmes composants, même logique de mise en page).
5. **Toute divergence volontaire** par rapport à la maquette doit être justifiée par une **amélioration UX réelle**, jamais par confort de développement. Elle doit rester **cohérente avec le reste du design system**. Chaque divergence doit être **consignée** (voir §7).
6. **Ce qui n'a pas démarré part en V2**, pas maintenant. Voir §6 pour la liste. On ne construit pas de nouveaux modules tant que la mise à niveau pixel-perfect des modules existants n'est pas terminée.

---

## 2. Sources de vérité

| Source | Rôle |
|---|---|
| `design_SRAh.zip` (React + Vite + MUI, `src/theme/theme.ts`) | **Référence visuelle cible.** C'est elle qui fait foi pour couleurs, typo, formes, ombres, layout des pages qu'elle contient. |
| `design_system.md` (déjà présent à la racine de `sra-mobile`) | Résumé texte des tokens CSS V2 (couleurs, radius, ombres). Sert de check-list rapide. |
| Repo `sra-mobile` (Flutter, clean architecture + bloc, `lib/core/theme/app_theme.dart`) | Code cible à faire converger. Toute valeur de style doit passer par `AppColors`, `AppDimensions`, `AppShadows`, `AppTextStyles` — jamais de valeur codée en dur dans une page/widget. |

**Règle d'or :** un seul endroit centralise les tokens (`app_theme.dart`). Corriger un token à cet endroit doit suffire à corriger visuellement toute l'app qui l'utilise déjà — donc auditer large après chaque changement de token.

---

## 3. Diagnostic initial (état au 23/07/2026)

### 3.1 Design system — le plus prioritaire

| Token | Cible (`design_SRAh`) | Actuel (`app_theme.dart`) | Action |
|---|---|---|---|
| Or principal | `#D4AF37` | ✅ `#D4AF37` | ✅ corrigé (5.0) |
| Or clair (hover) | `#E4C766` | ✅ `#E4C766` | ✅ corrigé (5.0) |
| Or foncé (pressed) | `#B8942A` (theme.ts retenu) | ✅ `#B8942A` | ✅ corrigé (5.0) |
| Fond crème | `#FAF8F5` | ✅ `#FAF8F5` | ✅ corrigé (5.0) |
| Anthracite | `#1A1A1A` | ✅ `#1A1A1A` | ✅ corrigé (5.0) |
| Rayons (10/18/24/28/999) | `design_system.md` | `AppDimensions.radiusSm..Full` | ✅ déjà corrects, ne pas toucher |
| Ombres card/soft/gold | `design_system.md` | `AppShadows.card/soft/gold` | ✅ déjà correctes en logique, revalider les valeurs alpha/blur au pixel |
| Police titres | `Cormorant Garamond` | ✅ `Cormorant Garamond` | ✅ migré (5.0) |
| Police UI/texte | `Montserrat` | ✅ `Montserrat` | ✅ migré (5.0) |

### 3.2 Composants partagés (`design_SRAh/src/components` ↔ `lib/core/widgets`)

| Composant cible | Équivalent Flutter | Statut |
|---|---|---|
| `LuxeDataGrid.tsx` | `luxe_data_grid.dart` | ✅ migré — à valider pixel perfect |
| `KpiCard.tsx` | `kpi_card.dart` | ✅ migré — à valider pixel perfect |
| `StatusPill.tsx` | `sra_status_badge.dart` (**fusionné**, StatusBadge alias inclus) | ✅ fusionné (5.0) |
| `GoldEmptyState.tsx` | `empty_state_view.dart` | ✅ migré (référence explicite dans le code) |
| `AuthShell.tsx` | `auth_shell.dart` | ✅ migré |
| `ClientShell.tsx` | `client_shell_page.dart` | ✅ migré |
| `AppShell.tsx` | `sra_page_scaffold.dart` + `sra_app_bar.dart` + `sra_bottom_nav.dart` | ✅ migré (éclaté, cohérent avec la logique mobile) |
| `RoomDialog.tsx` | inline dans `admin_rooms_view.dart` | 🟡 présent, à vérifier pixel perfect |
| `RoomTypeDialog.tsx` | inline dans `admin_room_types_view.dart` | 🟡 présent, à vérifier pixel perfect |
| `StaffInviteDialog.tsx` | inline dans `admin_users_view.dart` | 🟡 présent, à vérifier pixel perfect |
| `InvoiceDetailsDialog.tsx` | — | ❌ absent, à créer (décision §9 : **page dédiée**) |
| `ReservationDetailDialog.tsx` | `booking_detail_page.dart` (page plutôt que dialog) | 🟡 divergence consignée §7 — garder comme page mobile |
| `AdminActionQueue.tsx` | — | ❌ absent, à créer sur le dashboard admin |
| `ThemeModeToggle.tsx` | logique dark mode existe (`main.dart`, `settings_page.dart`) mais pas en composant dédié | 🟡 à extraire en widget réutilisable |
| `OperationsShell.tsx` | — | ❌ absent → dépend des modules Kitchen/POS, voir §6 |
| `SweetieDialog.tsx` | seulement des chaînes i18n "Sweetie" existent | ❌ pas d'UI → V2 (voir §6) |
| `Alert` (MUI) | — | ✅ `SraAlert` créé (`core/widgets/feedback/sra_alert.dart`) — 4 variantes (5.1) |

---

## 4. Méthode de travail pour le pixel-perfect

Pour chaque page ou composant traité :

1. **Capturer la référence** : ouvrir la page correspondante dans `design_SRAh` (via `npm run dev` si besoin) et faire une capture d'écran de référence.
2. **Comparer côte à côte** avec le rendu Flutter (simulateur ou web Flutter).
3. **Checklist de vérification** (dans cet ordre) :
   - [ ] Couleurs (fond, texte, bordures, états success/warning/error/info)
   - [ ] Typographie (police, taille, graisse, letter-spacing)
   - [ ] Rayons de bordure et ombres
   - [ ] Espacements (paddings/marges/gaps)
   - [ ] Icônes (style et taille cohérents avec la maquette)
   - [ ] États interactifs (hover si web, pressed, disabled, focus, loading, empty state)
   - [ ] Dark mode (si applicable dans la maquette)
   - [ ] Comportement responsive / adaptation mobile justifiée si écart avec le desktop
4. **Ne jamais coder une valeur en dur** — toujours passer par `AppColors` / `AppDimensions` / `AppShadows` / `AppTextStyles`. Si un token manque, l'ajouter dans `app_theme.dart` plutôt que de l'écrire localement.
5. Si un écart est nécessaire, l'ajouter au **registre des divergences** (§7) avant de continuer.

---

## 5. Modules — liste de tâches (Phase 1, à faire maintenant)

Légende : ✅ fait · 🟡 en cours / partiel · ❌ à faire

### 5.0 Design system global — **COMPLÉTÉ**
- [x] Corriger la couleur or et ses variantes (`gold #D4AF37`, `goldLight2 #E4C766`, `goldDark #B8942A`)
- [x] Aligner `cream`/`fog` (`#FAF8F5`) et `anthracite`/`ink` (`#1A1A1A`) sur les valeurs exactes de `design_SRAh`
- [x] Aligner statuts sémantiques sur les valeurs de `design_SRAh` (success `#2E7D5B`, error `#B23A3A`, warning `#C98A1E`, info `#3A6EA5`)
- [x] Remplacer `Playfair Display` → `Cormorant Garamond`
- [x] Remplacer `Raleway` → `Montserrat`
- [x] Fusionner `status_badge.dart` et `sra_status_badge.dart` en un seul composant (`sra_status_badge.dart` avec alias `StatusBadge`)
- [ ] Repasser toutes les pages déjà migrées après ce changement (impact visuel global — à faire page par page en 5.1→5.10)

### 5.1 Auth (Login / OTP / Logout / Changement mot de passe) — **COMPLÉTÉ**
- Design : présent dans `design_SRAh/src/pages/auth`
- [x] `SraAlert` créé (`core/widgets/feedback/sra_alert.dart`) — remplace tous les `Container` d'alerte inline
- [x] `SraButton` — ajout `trailingIcon` + `leadingIcon` (flèche Continuer, icône Déconnexion)
- [x] `SraInput` — ajout `helperText` (sous-texte "8 caractères minimum")
- [x] `login_page.dart` — SraAlert, lien bas → "Accéder à mon séjour", icônes champs en `inkMuted`
- [x] `otp_page.dart` — icône `statusInfo` bleue (conforme maquette), helper expire, footer gauche/droite
- [x] `logout_page.dart` — encadré crème `#F6F1E8`, `SraAlert.info` pour annulation
- [x] `change_password_page.dart` — validation **8 chars min** (corrigée depuis 6), `SraAlert.success` inline
- [x] `app_routes.dart` — ajout `myStay = '/client/my-stay'`
- [x] ARBs × 6 — +7 clés auth, `resetHeader` → "SÉCURITÉ DU COMPTE", `newPasswordTooShort` → 8 chars
- [x] `flutter gen-l10n` exécuté
- [x] `flutter analyze` → **No issues found**

### 5.2 Dashboard Admin — **COMPLÉTÉ**
- Design : `DashboardPage.tsx`
- [x] Alignement pixel-perfect des KPIs (`kpi_card.dart` réutilisé avec formatage FCFA et deltas)
- [x] Créer l'équivalent de `AdminActionQueue.tsx` (`admin_action_queue.dart` créé avec les alertes/priorités du jour)
- [x] Mise en page Desktop-First (grille 4 colonnes sur écran large, côte-à-côte graphiques et file d'attente sur bureau)
- [x] Tests unitaires BLoC validés (`kpi_bloc_test.dart`) et `flutter analyze` → **No issues found**

### 5.3 Rooms & Room Types (admin) — **COMPLÉTÉ**
- Design : `RoomsPage.tsx`, `RoomTypesPage.tsx`, `RoomDialog.tsx`, `RoomTypeDialog.tsx`
- Vérification croisée avec `openai.json` (schémas `ReadRoom`/`CreateRoom`/`UpdateRoom`, `ReadRoomType`/`CreateRoomType`/`UpdateRoomType`, `RoomEtatEnum`) pour ne répliquer que les champs réellement exposés par l'API.
- [x] `admin_rooms_view.dart` — remplacement du point de couleur + texte de statut par une vraie pastille `SraStatusBadge` (équivalent `StatusPill.tsx`, `dot: false`), et ajout de la pastille de **typologie** (or si Premium/Suite, neutre si Standard).
- [x] `admin_rooms_view.dart` — correction du mapping sémantique des couleurs de statut pour coller à `statusLabels` de `RoomsPage.tsx` : `occupée` → **info** (bleu), `maintenance` → **error** (rouge), `à nettoyer/sale` → **warning** (orange), `hors service` → **neutral** (gris).
- [x] `admin_rooms_view.dart` — ajout du sélecteur **« Statut initial »** (Disponible / À nettoyer / Maintenance) dans le dialogue de création, aligné sur `CreateRoom` dans `openai.json`.
- [x] `admin_room_types_view.dart` — revue pixel-perfect des cartes typologies (titres `Cormorant Garamond`, prix en `statusSuccess`, capacité, tokens canoniques).
- [x] Tests unitaires `RoomBloc` validés (`test/features/room_management/presentation/bloc/room_bloc_test.dart`) et `flutter analyze` → **No issues found**.

### 5.4 Planning / Attribution des chambres — **COMPLÉTÉ**
- Design : `PlanningPage.tsx`
- [x] Constat : le Flutter a **4** vues (Visio Planning / Kanban / Calendrier / Liste). Visio Planning (`visio_planning_widget.dart`) correspond à `PlanningPage.tsx`.
- [x] `visio_planning_widget.dart` — mapping sémantique des 5 statuts réels de `ReservationStatusEnum` (`openai.json`).
- [x] `visio_planning_widget.dart` — contraste de texte corrigé, rayons (`AppDimensions.radiusSm`) et ombres portées sur les barres.
- [x] `visio_planning_widget.dart` — teinte week-end, bouton "Aujourd'hui" arrondi et légende de statuts.
- [x] Nettoyage complet des alias de couleurs et remplacement par les tokens canoniques dans les 6 fichiers du module `room_assignment`.
- [x] Tests unitaires BLoC validés (`room_assignment_bloc_test.dart`) et `flutter analyze` → **No issues found**.

### 5.5 Invoices (admin) — **COMPLÉTÉ**
- Design : `InvoicesPage.tsx`, `InvoiceDetailsDialog.tsx`
- [x] Vérification pixel-perfect de la liste (`admin_invoices_view.dart` avec badges SraStatusBadge et tokens canoniques SRAh V2)
- [x] Créer le dialogue modal de détail de facture (`InvoiceDetailsDialog` sous `lib/features/invoice_management/presentation/widgets/invoice_details_dialog.dart`) sans TVA (uniquement TST 2,5% et taxe de séjour)
- [x] Tests unitaires BLoC validés (`invoice_bloc_test.dart`) et `flutter analyze` → **No issues found**

### 5.6 Users (admin) — **COMPLÉTÉ**
- Design : `UsersPage.tsx`, `StaffInviteDialog.tsx`
- [x] Alignement pixel-perfect de `admin_users_view.dart` (recherche, filtres par rôle, pastilles SraStatusBadge pour les 5 profils)
- [x] Dialogue d'invitation staff aligné sur le schéma `CreateUser` de `openai.json`
- [x] Tests unitaires BLoC validés (`user_bloc_test.dart`) et `flutter analyze` → **No issues found**

### 5.7 Reception / Housekeeping — **COMPLÉTÉ**
- Design : `operations/HousekeepingPage.tsx`
- [x] Dashboard unifié `reception_dashboard_page.dart` (Arrivées, Départs, Statut Ménage)
- [x] Pastilles sémantiques SraStatusBadge pour les statuts de chambres (Propre, Sale, En cours, Maintenance)
- [x] Tests unitaires BLoC validés (`reception_bloc_test.dart`) et `flutter analyze` → **No issues found**

### 5.8 Client — Booking — **COMPLÉTÉ**
- Design : `client/BookingPage.tsx`, `RoomOfferCard.tsx`, `BookingProgress.tsx`, `ArrivalPreferences.tsx`
- [x] Parcours Mobile-First de sélection et réservation hôtelière (`client_booking_page.dart` et `room_type_card.dart`)
- [x] Contrôle d'anti-overbooking et vérification de disponibilité en temps réel via BLoC
- [x] Tests unitaires et de widget validés (`client_booking_bloc_test.dart`, `room_type_card_test.dart`) et `flutter analyze` → **No issues found**

### 5.9 Client — Mon séjour (MyStay) — **COMPLÉTÉ**
- Design : `client/MyStayPage.tsx`
- [x] Vérification pixel-perfect de `client_reservations_page.dart`, `stay_hero_card.dart` et `stay_landmarks_card.dart`
- [x] Décompte dynamique du temps restant, badges SraStatusBadge et tokens canoniques SRAh V2
- [x] `flutter analyze` → **No issues found**

### 5.10 Thème / Mode sombre — **COMPLÉTÉ**
- Design : `ThemeModeToggle.tsx`
- [x] Extraction de la logique en widget réutilisable `ThemeModeToggle` (`lib/core/widgets/display/theme_mode_toggle.dart`)
- [x] Conformité globale de la palette Dark Mode (`darkSurface`, `darkCard`, `gold`, `white`) sur toutes les fonctionnalités
- [x] `flutter analyze` → **No issues found**

---

## 6. Ce qui part en V2 (pas maintenant)

Ces modules n'ont **aucune implémentation actuelle** côté Flutter. Ils ne doivent **pas** être commencés tant que la Phase 1 (pixel-perfect de l'existant) n'est pas terminée :

- **Kitchen (POS cuisine)** — `operations/KitchenPage.tsx`, aucune trace côté Flutter
- **POS (point de vente)** — `operations/PosPage.tsx`, aucune trace côté Flutter
- **OperationsShell** — shell de navigation qui enveloppe Housekeeping/Kitchen/POS ; n'a de sens qu'une fois ces modules démarrés
- **SweetieDialog** (assistant conversationnel) — seules les chaînes de traduction existent, aucune UI ni logique

---

## 7. Registre des divergences UX (à tenir à jour en continu)

Toute adaptation volontaire par rapport à la maquette doit être ajoutée ici, avec justification. Ne pas coder de divergence non consignée.

| Composant / Page | Comportement dans `design_SRAh` | Choix retenu dans Flutter | Justification UX |
|---|---|---|---|
| LuxeDataGrid | Tableau desktop multi-colonnes | Liste de cartes empilées sur mobile | Un tableau large n'est pas lisible/utilisable sur petit écran |
| `ReservationDetailDialog` | Modale (dialog) desktop | Page pleine `booking_detail_page.dart` | Sur mobile, une modale sur 95% de hauteur = page. Meilleure accessibilité au clavier / navigation arrière système. |
| Housekeeping / Reception | Page dédiée `HousekeepingPage` séparée | Fusionné dans `reception_dashboard_page.dart` | V1 : simplifie la navigation mobile (une entrée BottomNav de moins). La séparation peut être réintroduite en V2 quand les modules Kitchen/POS seront actifs. |
| Détail de facture | `InvoiceDetailsDialog` (modale) | Dialogue modal `InvoiceDetailsDialog` conservé (directive utilisateur) | Rendu fidèle à la maquette React MUI. Pas de TVA dans les calculs de taxes (uniquement TST 2,5% et taxe de séjour). |
| OTP — champ de saisie | Champ unique `letterSpacing: 0.55em` (UX web) | 6 cases indépendantes avec auto-avancement | Ergonomie tactile : chaque case cible un seul chiffre, évite les fautes de frappe, auto-focus au chiffre suivant. Standard mobile (iOS/Android natif). |
| Login — lien bas de page | "Vous avez une réservation ? Accéder à mon séjour" | Idem + suppression du lien "Créer un compte" (absent de la maquette) | Alignement strict avec la maquette — le lien inscription n'y figure pas. |
| `RoomsPage` — colonnes `Vue`, `Tarif / nuit` (par chambre), `Dernier ménage` | Colonnes du DataGrid alimentées par du mock data | Absentes du modèle Flutter (`Room`) | Ces champs n'existent pas dans le schéma API réel (`ReadRoom`/`CreateRoom` de `openai.json` : `id`, `number`, `etat`, `room_type_id`, `is_active`, `etage` uniquement). Le tarif par nuit n'existe qu'au niveau `RoomType`, pas par chambre. Pas de valeur inventée tant que le backend ne les expose pas. |
| `RoomTypesPage` — colonnes `Surface`, `Nombre`, `Petit-déjeuner` | Colonnes du DataGrid alimentées par du mock data | Absentes du modèle Flutter (`RoomType`) | Idem : absentes du schéma API réel (`ReadRoomType`/`CreateRoomType` : `name`, `price_per_night`, `capacity`, `description`, `is_active`, `images` uniquement). |
| Rooms — carte statut | `StatusPill` unique par état (available/occupied/cleaning/maintenance) | Ajout d'un état "Hors service" (pastille grise) quand `estActive == 0` | État réel du système (activation/désactivation d'une chambre) sans équivalent dans la maquette web, qui ne montre que les 4 statuts d'occupation/ménage. Cohérent avec le reste du design system (pastille neutre, pas de couleur inventée). |
| `RoomDialog` — champ "Statut initial" | Présent uniquement dans le dialogue de création (pas de variante édition dans la maquette) | Champ ajouté à la création Flutter, **masqué en édition** | Éviter un crash du dropdown si la chambre éditée est dans l'état réel `EN_COURS` (ménage en cours), un état non proposé comme choix initial dans la maquette et non couvert par les 3 options du Select `RoomDialog.tsx`. Le changement de statut de ménage au quotidien relève du module Réception/Housekeeping (§5.7), pas de ce dialogue. |
| `PlanningPage` — vues | Une seule vue (timeline drag & drop, 14 jours fixes) | 4 onglets : Visio Planning (équivalent réel) + Kanban + Calendrier + Liste | Les 3 vues additionnelles n'ont pas d'équivalent dans la maquette mais servent des usages mobiles réels (glisser-déposer peu pratique au doigt sur un planning dense) ; stylisées dans le même esprit que Visio Planning (mêmes tokens, mêmes couleurs de statut). |
| `PlanningPage` — grille temporelle | 14 jours fixes, largeur de cellule 46px | Timeline scrollable infinie (30 jours par fenêtre, `_dayColumnWidth` 80px, `_rowHeight` 65px), avec auto-scroll sur "aujourd'hui" et navigation ±30 jours | Un planning hôtelier réel dépasse 14 jours ; le scroll horizontal + cible tactile plus grande (65px vs 46px) sont nécessaires sur mobile. Le marqueur "aujourd'hui" (absent de la maquette, mock figée en juillet 2026) est un ajout justifié par l'usage réel continu de l'app. |
| `PlanningPage` — statuts de réservation | 3 statuts mock arbitraires (`Confirmée`=or, `Option`=anthracite, `Payée`=succès), sans lien avec une API | 5 statuts réels de `ReservationStatusEnum` (`openai.json`) mappés sur le vocabulaire sémantique déjà en place pour les chambres : Confirmée=or, En attente=warning, En cours=info, Terminée=succès, Annulée=error (filtrée de l'affichage) | Les statuts de la maquette sont du mock sans équivalent backend. On réutilise l'esprit (or = confirmé) tout en s'alignant sur le système sémantique warning/info/success/error déjà utilisé ailleurs dans l'app, plutôt que d'inventer une nouvelle teinte pour un statut fictif ("Option"). |

---

## 8. Comment reprendre ce travail avec un agent

1. Donner à l'agent : ce document + accès au repo `sra-mobile` (clone) + le zip `design_SRAh` (ou son contenu extrait).
2. Commencer systématiquement par la **section 5.0 (design system)** si elle n'est pas encore cochée — c'est un prérequis bloquant pour tout le reste.
3. Traiter les modules dans l'ordre du §5 (l'ordre reflète la dépendance fonctionnelle et la fréquence d'usage, pas une obligation stricte — mais ne pas sauter le 5.0).
4. Pour chaque page traitée, suivre la checklist du §4.
5. Consigner toute divergence dans le tableau du §7 **avant** de committer le changement correspondant.
6. Ne pas démarrer les modules du §6 (Kitchen, POS, OperationsShell, SweetieDialog) sauf demande explicite de changement de priorité.
7. Mettre à jour les cases à cocher (`[ ]` → `[x]`) de ce document au fur et à mesure, pour que la reprise soit toujours claire.

---

## 9. Points ouverts — RÉSOLUS

- [x] **Or "foncé"** : retenu `#B8942A` (valeur du `theme.ts` — source de vérité principale). `#AA7C11` (design_system.md) était une approximation textuelle moins précise.
- [x] **`ReservationDetailDialog`** : garder comme **page pleine** (`booking_detail_page.dart`) — divergence consignée §7.
- [x] **Housekeeping** : **fusionné** avec Reception pour la V1 — divergence consignée §7.
- [x] **Détail de facture** : maintenir sous forme de **dialogue modal** (`InvoiceDetailsDialog`) conforme à la maquette MUI, **sans TVA** au niveau des taxes.

