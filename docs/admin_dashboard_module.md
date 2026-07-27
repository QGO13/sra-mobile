# Module Dashboard Admin & KPIs (Jet 1 & Jet 4)

Ce document décrit l'architecture et les spécifications visuelles du module **Dashboard Administration & KPIs** (`admin_dashboard` et `backoffice_kpis`).

---

## 1. Clean Architecture & Structuration

Le module est découpé selon les règles de la Clean Architecture sous `lib/features/admin_dashboard/` et `lib/features/backoffice_kpis/` :

*   **👥 Domain Layer :**
    *   `KpiData` : Entité contenant les valeurs financières et d'occupation (CA mensuel, taux d'occupation, RevPAR, panier moyen, deltas d'évolution).
    *   `HistoryData` : Entité des séries temporelles (historique de revenu et taux d'occupation sur 6 à 12 mois).
    *   `GetKpisUseCase`, `GetHistoryUseCase` : Cas d'usage d'extraction des indicateurs.
*   **🗄️ Data Layer :**
    *   `KpiModel`, `HistoryModel` : Modèles avec sérialisation JSON (`fromJson`/`toJson`).
    *   `KpiRemoteDataSource` : Appels API vers `/api/v1/admin/kpis` et `/api/v1/admin/kpis/history`.
    *   `KpiRepositoryImpl` : Implémentation du contrat métier.
*   **🎨 Presentation Layer :**
    *   `KpiBloc` : Gestion des états du tableau de bord (`KpiInitial`, `KpiLoading`, `KpiLoaded`, `KpiFailure`).
    *   `AdminDashboardPage` : Shell d'administration responsive (Sidebar permanente `AdminSidebarWidget` sur bureau, `BottomNavigationBar` sur mobile).
    *   `AdminKpisView` : Vue d'ensemble avec mise en page Desktop-First (grille 4 colonnes de cartes `KpiCard`, graphiques de tendance et `AdminActionQueue`).
    *   `AdminActionQueue` : Composant des alertes et tâches prioritaires du jour (aligné sur `AdminActionQueue.tsx` de SRAh V2).

---

## 2. Spécifications Visuelles & Ergonomie Responsive

*   **Cartes KPI (`KpiCard`) :** Utilisation du composant canonique `KpiCard` avec badge de tendance sémantique (vert `statusSuccess` pour hausse, rouge `statusError` pour baisse), typographies `Cormorant Garamond` (valeurs) et `Montserrat` (titres).
*   **File d'actions (`AdminActionQueue`) :** Module d'alertes en temps réel affichant les réservations à attribuer, factures à valider, alertes de maintenance et inspections d'étages.
*   **Ergonomie Responsive (Desktop-First) :**
    *   `isWide >= 1024px` : Grille 4 colonnes pour les KPIs, disposition côte-à-côte des graphiques et de la file d'attente d'actions.
    *   `isMobile < 1024px` : Grille 2 colonnes pour les KPIs, empilement vertical des graphiques et de la file d'attente d'actions.

---

## 3. Validation & Qualité Code

*   **Tests Unitaires :** Validés dans `test/features/backoffice_kpis/presentation/bloc/kpi_bloc_test.dart` (États BLoC et UseCases).
*   **Analyse Statique :** `flutter analyze` -> 0 erreur, 0 warning.
*   **Internationalisation :** Clefs l10n gérées dans les 6 langues (`fr`, `en`, `es`, `de`, `ar`, `zh`).
