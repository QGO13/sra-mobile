import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Chip de filtre/sélection SRA Hotel — style pilule avec état actif doré.
class SraChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? activeColor;

  const SraChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = activeColor ?? AppColors.gold;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
          vertical: AppDimensions.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? goldColor
              : (isDark ? AppColors.darkElevated : AppColors.mist),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected
                ? goldColor
                : (isDark ? AppColors.darkBorder : AppColors.mist),
            width: AppDimensions.borderThin,
          ),
          boxShadow: isSelected ? const [AppShadows.goldDisabled] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppDimensions.iconSizeSm,
                color: isSelected
                    ? AppColors.white
                    : (isDark ? AppColors.white : AppColors.inkSoft),
              ),
              AppDimensions.hGapXs,
            ],
            Text(
              label,
              style: AppTextStyles.labelNormal.copyWith(
                color: isSelected
                    ? AppColors.white
                    : (isDark ? AppColors.white : AppColors.inkSoft),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
