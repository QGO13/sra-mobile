import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Pill-shaped semantic status badge with a coloured indicator dot et support Dark Mode.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double dotSize  = small ? AppDimensions.spacingSm  : AppDimensions.spacingSm + AppDimensions.spacingXs;
    final double hPadding = small ? AppDimensions.spacingSm  : AppDimensions.spacingMd;
    final double vPadding = small ? AppDimensions.spacingXs  : AppDimensions.spacingXs + AppDimensions.borderMedium;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: vPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.4 : 0.25),
          width: AppDimensions.borderThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          AppDimensions.hGapXs,
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelUppercase.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
