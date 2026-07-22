import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Pill-shaped semantic status badge with a coloured indicator dot.
///
/// Usage:
/// ```dart
/// StatusBadge(label: 'Payée', color: AppColors.statusSuccess)
/// StatusBadge(label: 'Annulée', color: AppColors.statusError, small: true)
/// ```
class StatusBadge extends StatelessWidget {
  /// The text displayed inside the badge (rendered uppercase).
  final String label;

  /// Semantic colour for the dot, text, and tinted background.
  /// Use constants from [AppColors] (e.g. `AppColors.statusSuccess`).
  final Color color;

  /// When true, renders a compact variant with reduced padding and dot size.
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final double dotSize   = small ? AppDimensions.spacingSm  : AppDimensions.spacingSm + AppDimensions.spacingXs;
    final double hPadding  = small ? AppDimensions.spacingSm  : AppDimensions.spacingMd;
    final double vPadding  = small ? AppDimensions.spacingXs  : AppDimensions.spacingXs + 2.0;
    final double gapSize   = small ? AppDimensions.spacingXs  : AppDimensions.spacingSm;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: vPadding,
      ),
      decoration: BoxDecoration(
        // 10 % opacity tint of the semantic colour
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Coloured indicator dot ──────────────────────────────────────
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: gapSize),
          // ── Label ───────────────────────────────────────────────────────
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelUppercase.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
