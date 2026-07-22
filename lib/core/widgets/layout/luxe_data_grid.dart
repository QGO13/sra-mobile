import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/cards/sra_card.dart';
import 'package:sra_hotel/core/widgets/feedback/empty_state_view.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';

/// Définition d'une colonne pour LuxeDataGrid
class LuxeGridColumn<T> {
  final String title;
  final Widget Function(BuildContext context, T item) cellBuilder;
  final double flex;
  final AlignmentGeometry alignment;

  const LuxeGridColumn({
    required this.title,
    required this.cellBuilder,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  });
}

/// LuxeDataGrid — Composant universel de tableau de données adaptatif Luxe.
///
/// Sur Desktop / Tablette (isWide) : Affiche une table de données stylisée avec en-têtes Or et bordures fines.
/// Sur Mobile : Affiche une liste réactive de cartes via `mobileCardBuilder`.
class LuxeDataGrid<T> extends StatefulWidget {
  final List<T> items;
  final List<LuxeGridColumn<T>> columns;
  final Widget Function(BuildContext context, T item) mobileCardBuilder;
  final String? searchPlaceholder;
  final bool Function(T item, String query)? searchFilter;
  final Widget? emptyState;
  final String? emptyTitle;
  final String? emptySubtitle;

  const LuxeDataGrid({
    super.key,
    required this.items,
    required this.columns,
    required this.mobileCardBuilder,
    this.searchPlaceholder,
    this.searchFilter,
    this.emptyState,
    this.emptyTitle,
    this.emptySubtitle,
  });

  @override
  State<LuxeDataGrid<T>> createState() => _LuxeDataGridState<T>();
}

class _LuxeDataGridState<T> extends State<LuxeDataGrid<T>> {
  late final TextEditingController _searchCtrl;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<T> get _filteredItems {
    if (_searchQuery.isEmpty || widget.searchFilter == null) {
      return widget.items;
    }
    return widget.items.where((item) => widget.searchFilter!(item, _searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width >= AppDimensions.breakpointMd;
    final filtered = _filteredItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Barre de recherche rapide Luxe ────────────────────────────────────
        if (widget.searchFilter != null) ...[
          SraInput(
            controller: _searchCtrl,
            placeholder: widget.searchPlaceholder ?? 'Rechercher...',
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: AppDimensions.iconSizeSm),
                    onPressed: () => _searchCtrl.clear(),
                  )
                : null,
          ),
          AppDimensions.vGapMd,
        ],

        // ── Grille / Liste ───────────────────────────────────────────────────
        if (filtered.isEmpty)
          widget.emptyState ??
              EmptyStateView(
                icon: Icons.search_off_rounded,
                title: widget.emptyTitle ?? 'Aucun résultat trouvé',
                subtitle: widget.emptySubtitle ?? 'Essayez de modifier votre recherche.',
              )
        else if (isWide)
          _buildDesktopTable(context, filtered, isDark)
        else
          _buildMobileList(context, filtered),
      ],
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<T> items, bool isDark) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.mist;
    final headerBg = isDark ? AppColors.darkElevated : AppColors.fog;

    return SraCard.flat(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Column(
          children: [
            // En-tête de table
            Container(
              color: headerBg,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingSm,
              ),
              child: Row(
                children: widget.columns.map((col) {
                  return Expanded(
                    flex: (col.flex * 100).toInt(),
                    child: Container(
                      alignment: col.alignment,
                      child: Text(
                        col.title.toUpperCase(),
                        style: AppTextStyles.buttonLabelSm.copyWith(
                          color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),

            // Lignes du tableau
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => Divider(height: 1, thickness: 0.5, color: borderColor),
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd,
                    vertical: AppDimensions.spacingSm,
                  ),
                  child: Row(
                    children: widget.columns.map((col) {
                      return Expanded(
                        flex: (col.flex * 100).toInt(),
                        child: Container(
                          alignment: col.alignment,
                          child: col.cellBuilder(context, item),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<T> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => AppDimensions.vGapMd,
      itemBuilder: (context, index) => widget.mobileCardBuilder(context, items[index]),
    );
  }
}
