import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/cards/sra_card.dart';
import 'package:sra_hotel/core/widgets/feedback/empty_state_view.dart';

/// Définition d'une colonne de tableau pour SraDataTable
class SraTableColumn<T> {
  final String label;
  final Widget Function(BuildContext context, T item) cellBuilder;
  final double flex;
  final AlignmentGeometry alignment;

  const SraTableColumn({
    required this.label,
    required this.cellBuilder,
    this.flex = 1.0,
    this.alignment = Alignment.centerLeft,
  });
}

/// SraDataTable — Composant universel de Tableau de données Admin avec scroll 2D.
///
/// Affiche une structure en tableau propre avec en-tête doré, bordures fines,
/// défilement horizontal fluide et défilement vertical d'éléments (2D scroll).
class SraDataTable<T> extends StatelessWidget {
  final List<T> items;
  final List<SraTableColumn<T>> columns;
  final Widget? emptyState;
  final String? emptyTitle;
  final IconData? emptyIcon;
  final double minWidth;

  const SraDataTable({
    super.key,
    required this.items,
    required this.columns,
    this.emptyState,
    this.emptyTitle,
    this.emptyIcon,
    this.minWidth = 600.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.mist;
    final headerBg = isDark ? AppColors.darkCard : AppColors.fog;

    if (items.isEmpty) {
      return emptyState ??
          EmptyStateView(
            icon: emptyIcon ?? Icons.table_rows_outlined,
            title: emptyTitle ?? 'Aucune donnée disponible',
          );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth < minWidth ? minWidth : constraints.maxWidth;
        final isBoundedHeight = constraints.maxHeight.isFinite;

        Widget listWidget = ListView.separated(
          shrinkWrap: !isBoundedHeight,
          physics: isBoundedHeight ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, _) => Divider(height: 1, thickness: 0.5, color: borderColor),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              color: index.isEven
                  ? Colors.transparent
                  : (isDark ? AppColors.white.withValues(alpha: 0.02) : AppColors.fog.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingSm,
              ),
              child: Row(
                children: columns.map((col) {
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
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            height: isBoundedHeight ? constraints.maxHeight : null,
            child: SraCard.flat(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                child: Column(
                  children: [
                    // ── En-tête de Table (Fixe en haut) ─────────────────────
                    Container(
                      color: headerBg,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingMd,
                        vertical: AppDimensions.spacingSm + 2,
                      ),
                      child: Row(
                        children: columns.map((col) {
                          return Expanded(
                            flex: (col.flex * 100).toInt(),
                            child: Container(
                              alignment: col.alignment,
                              child: Text(
                                col.label.toUpperCase(),
                                style: AppTextStyles.buttonLabelSm.copyWith(
                                  color: isDark ? AppColors.goldLight2 : AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: borderColor),

                    // ── Lignes de Données (Scrollable verticalement) ────────
                    if (isBoundedHeight)
                      Expanded(child: listWidget)
                    else
                      listWidget,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
