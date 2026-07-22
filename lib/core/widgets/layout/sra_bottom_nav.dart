import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Item de la barre de navigation inférieure SRA.
class SraBottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? badgeText;

  const SraBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeText,
  });
}

/// Navigation inférieure SRA Hotel — indicateur doré animé + badges avec support Dark Mode.
class SraBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<SraBottomNavItem> items;

  const SraBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.mist,
            width: AppDimensions.borderThin,
          ),
        ),
        boxShadow: const [AppShadows.card],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          final color = isSelected ? AppColors.gold : AppColors.inkMuted;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                        color: color,
                        size: AppDimensions.iconSizeLg,
                      ),
                      if (item.badgeText != null)
                        Positioned(
                          right: -AppDimensions.spacingSm,
                          top: -AppDimensions.spacingXs,
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.borderThick),
                            decoration: const BoxDecoration(
                              color: AppColors.statusError,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: AppDimensions.iconSizeSm,
                              minHeight: AppDimensions.iconSizeSm,
                            ),
                            child: Text(
                              item.badgeText!,
                              style: AppTextStyles.labelUppercase.copyWith(
                                color: AppColors.white,
                                fontSize: AppDimensions.spacingSm,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    item.label,
                    style: AppTextStyles.buttonLabelSm.copyWith(
                      color: color,
                      fontSize: AppDimensions.spacingSm + 1,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: AppDimensions.borderThick,
                    width: isSelected ? AppDimensions.iconSizeSm : 0,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
