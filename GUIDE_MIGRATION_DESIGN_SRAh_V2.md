# Guide de migration — Design SRAh V2 (sra-mobile)

> Document de cadrage à donner tel quel à tout agent (Claude ou autre) qui reprend le travail.
> Dernière mise à jour : 24 juillet 2026 — **5.1 complété** (Auth pixel-perfect + SraAlert + nouveaux tokens SraButton/SraInput) · **5.3 en cours** (Rooms & Room Types admin — pastilles de statut/typologie corrigées, écart de données consigné §7, revue visuelle finale restant à faire).

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

### 5.2 Dashboard Admin
- Design : `DashboardPage.tsx`
- [ ] Vérification pixel-perfect des KPIs (`kpi_card.dart`)
- [ ] Créer l'équivalent de `AdminActionQueue.tsx` (liste d'actions à traiter) — absent actuellement
- [ ] Vérifier les graphiques (`kpi_charts.dart`) vs la maquette

### 5.3 Rooms & Room Types (admin) — **EN COURS**
- Design : `RoomsPage.tsx`, `RoomTypesPage.tsx`, `RoomDialog.tsx`, `RoomTypeDialog.tsx`
- Vérification croisée avec `openai.json` (schémas `ReadRoom`/`CreateRoom`/`UpdateRoom`, `ReadRoomType`/`CreateRoomType`/`UpdateRoomType`, `RoomEtatEnum`) pour ne répliquer que les champs réellement exposés par l'API. Constat : les colonnes `view`, `pricePerNight` (par chambre), `surface`, `count` et `breakfastIncluded` du mock React n'ont **aucun équivalent côté backend/entités Flutter** (`Room`, `RoomType`) — c'est du mock data de maquette, pas des champs réels. Non reproductibles tant que le backend ne les expose pas (voir divergence §7).
- [x] `admin_rooms_view.dart` — remplacement du point de couleur + texte de statut par une vraie pastille `SraStatusBadge` (équivalent `StatusPill.tsx`, `dot: false`), et ajout de la pastille de **typologie** (or si Premium/Suite, neutre si Standard) qui manquait entièrement
- [x] `admin_rooms_view.dart` — correction du mapping sémantique des couleurs de statut pour coller à `statusLabels` de `RoomsPage.tsx` : `occupée` → **info** (bleu, était à tort en or), `maintenance` → **error** (rouge), `à nettoyer/sale` → **warning** (orange, était à tort en rouge). `Hors service` reste un état réel supplémentaire hors maquette (dot supprimé, converti en pastille grise)
- [x] `admin_rooms_view.dart` — ajout du sélecteur **« Statut initial »** (Disponible / À nettoyer / Maintenance) dans le dialogue de création, absent jusqu'ici alors que `etat` est un champ **requis** par `CreateRoom` dans `openai.json` (valeur hardcodée `"PROPRE"` auparavant). Limité à la création uniquement (comme `RoomDialog.tsx`, qui ne gère pas l'édition) pour éviter un crash `DropdownButtonFormField` si une chambre en édition est dans l'état réel `EN_COURS`, non proposé comme choix initial dans la maquette. +4 clés ARB × 6 langues (`roomInitialStatusLabel`, `roomStatusAvailable`, `roomStatusToClean`, `roomStatusMaintenance`) — fichiers `app_localizations*.dart` édités à la main (pas de SDK Flutter dans cet agent pour lancer `flutter gen-l10n` ; à revalider par un agent/humain avec l'outil)
- [ ] `admin_room_types_view.dart` — revue pixel-perfect fine (radius/ombre/espacements déjà conformes aux tokens ; le nom en titre plein texte plutôt qu'en pastille dorée est une adaptation cohérente avec le reste des cartes de l'app mobile, pas une pastille de donnée manquante — à confirmer visuellement)
- [ ] Vérification pixel-perfect des dialogues de création/édition (actuellement inline dans les pages — c'est acceptable, pas besoin de les extraire sauf si ça simplifie la maintenance). Structure des champs déjà cohérente avec les schémas `CreateRoom`/`CreateRoomType` de `openai.json`
- [ ] Revue visuelle côte-à-côte (capture React `npm run dev` vs simulateur Flutter) — non faite dans cette passe (pas d'environnement graphique dans cet agent), à valider par un agent/humain avec accès visuel avant de cocher définitivement 5.3

### 5.4 Planning / Attribution des chambres
- Design : `PlanningPage.tsx`
- [ ] Vérification pixel-perfect de `room_assignment_dashboard_page.dart`
- [ ] Note : le Flutter a 3 vues (calendrier / kanban / liste) — la maquette n'en montre peut-être qu'une. Si les vues supplémentaires servent l'usage mobile, les garder mais les styliser dans le même esprit que la vue de référence (voir §7 pour consignation).

### 5.5 Invoices (admin)
- Design : `InvoicesPage.tsx`, `InvoiceDetailsDialog.tsx`
- [ ] Vérification pixel-perfect de la liste (`admin_invoices_view.dart`)
- [ ] Créer le détail de facture — **choix retenu : page dédiée** (voir §7 et §9 résolu)

### 5.6 Users (admin)
- Design : `UsersPage.tsx`, `StaffInviteDialog.tsx`
- [ ] Vérification pixel-perfect de `admin_users_view.dart`
- [ ] Vérification pixel-perfect du dialog d'invitation (inline actuellement)

### 5.7 Reception / Housekeeping
- Design : `operations/HousekeepingPage.tsx`
- État actuel : fonctionnalité fusionnée dans `reception_dashboard_page.dart`
- **Décision retenue : garder la fusion réception+ménage** pour la V1 (allège la navigation mobile — consigné §7)
- [ ] Vérification pixel-perfect des indicateurs de statut chambre (propre/sale/maintenance)

### 5.8 Client — Booking
- Design : `client/BookingPage.tsx`, `RoomOfferCard.tsx`, `BookingProgress.tsx`, `ArrivalPreferences.tsx`
- [ ] Vérification pixel-perfect de `client_booking_page.dart` et widgets associés (déjà bien avancés)

### 5.9 Client — Mon séjour (MyStay)
- Design : `client/MyStayPage.tsx`
- [ ] Vérification pixel-perfect de `client_reservations_page.dart`, `stay_hero_card.dart`, `stay_landmarks_card.dart`

### 5.10 Thème / Mode sombre
- Design : `ThemeModeToggle.tsx`
- [ ] Extraire la logique existante en un composant dédié réutilisable
- [ ] Vérifier la palette dark mode sur toutes les pages déjà migrées

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
| Détail de facture | `InvoiceDetailsDialog` (modale) | Page dédiée à créer (5.5) | Sur mobile, une modale dense de facture → meilleure lisibilité + partage/impression plus naturels depuis une page. |
| OTP — champ de saisie | Champ unique `letterSpacing: 0.55em` (UX web) | 6 cases indépendantes avec auto-avancement | Ergonomie tactile : chaque case cible un seul chiffre, évite les fautes de frappe, auto-focus au chiffre suivant. Standard mobile (iOS/Android natif). |
| Login — lien bas de page | "Vous avez une réservation ? Accéder à mon séjour" | Idem + suppression du lien "Créer un compte" (absent de la maquette) | Alignement strict avec la maquette — le lien inscription n'y figure pas. |
| `RoomsPage` — colonnes `Vue`, `Tarif / nuit` (par chambre), `Dernier ménage` | Colonnes du DataGrid alimentées par du mock data | Absentes du modèle Flutter (`Room`) | Ces champs n'existent pas dans le schéma API réel (`ReadRoom`/`CreateRoom` de `openai.json` : `id`, `number`, `etat`, `room_type_id`, `is_active`, `etage` uniquement). Le tarif par nuit n'existe qu'au niveau `RoomType`, pas par chambre. Pas de valeur inventée tant que le backend ne les expose pas. |
| `RoomTypesPage` — colonnes `Surface`, `Nombre`, `Petit-déjeuner` | Colonnes du DataGrid alimentées par du mock data | Absentes du modèle Flutter (`RoomType`) | Idem : absentes du schéma API réel (`ReadRoomType`/`CreateRoomType` : `name`, `price_per_night`, `capacity`, `description`, `is_active`, `images` uniquement). |
| Rooms — carte statut | `StatusPill` unique par état (available/occupied/cleaning/maintenance) | Ajout d'un état "Hors service" (pastille grise) quand `estActive == 0` | État réel du système (activation/désactivation d'une chambre) sans équivalent dans la maquette web, qui ne montre que les 4 statuts d'occupation/ménage. Cohérent avec le reste du design system (pastille neutre, pas de couleur inventée). |
| `RoomDialog` — champ "Statut initial" | Présent uniquement dans le dialogue de création (pas de variante édition dans la maquette) | Champ ajouté à la création Flutter, **masqué en édition** | Éviter un crash du dropdown si la chambre éditée est dans l'état réel `EN_COURS` (ménage en cours), un état non proposé comme choix initial dans la maquette et non couvert par les 3 options du Select `RoomDialog.tsx`. Le changement de statut de ménage au quotidien relève du module Réception/Housekeeping (§5.7), pas de ce dialogue. |

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
- [x] **Détail de facture** : créer une **page dédiée** (pas une modale) — divergence consignée §7. À implémenter en 5.5.
