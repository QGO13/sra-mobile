import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Item de filtre pour [SraFilterBar].
class SraFilterItem {
  final String id;
  final String label;
  final IconData? icon;
  final int? count;

  const SraFilterItem({
    required this.id,
    required this.label,
    this.icon,
    this.count,
  });
}

/// Bar de Filtres Standardisée — Design Flat Luxury SRA Hotel.
///
/// Utilisable à travers toute l'application pour garantir un style de filtres
/// uniforme, réactif et élégant en mode Clair et Sombre.
class SraFilterBar extends StatelessWidget {
  final List<SraFilterItem> items;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final EdgeInsetsGeometry padding;

  const SraFilterBar({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: padding,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedId == item.id;

          return Padding(
            padding: EdgeInsets.only(
              right: index == items.length - 1 ? 0 : AppDimensions.spacingSm,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(item.id),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.champagneGold
                        : (isDark ? AppColors.deepBlue : Colors.white),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.champagneGold
                          : (isDark ? Colors.white10 : AppColors.softGrey),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.champagneGold.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                      ] else if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          size: 14,
                          color: isDark ? Colors.white70 : AppColors.imperialNightBlue,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : AppColors.imperialNightBlue),
                        ),
                      ),
                      if (item.count != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.25)
                                : (isDark ? Colors.white10 : AppColors.fog),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          ),
                          child: Text(
                            '${item.count}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : AppColors.inkMuted),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
