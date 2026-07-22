import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Séparateur SRA Hotel — ligne fine, avec label central optionnel.
///
/// ```dart
/// const SraDivider()
/// const SraDivider.gold()
/// SraDivider.label(text: 'ou continuer avec')
/// ```
class SraDivider extends StatelessWidget {
  final String? label;
  final bool gold;
  final double? height;

  const SraDivider({super.key, this.label, this.gold = false, this.height});

  const SraDivider.gold({Key? key, double? height})
      : this(key: key, gold: true, height: height);

  const SraDivider.label({Key? key, required String text, double? height})
      : this(key: key, label: text, height: height);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor = gold
        ? AppColors.gold.withValues(alpha: 0.4)
        : (isDark ? AppColors.darkBorder : AppColors.mist);

    if (label == null) {
      return Divider(
        color: lineColor,
        thickness: AppDimensions.borderHair,
        height: height ?? AppDimensions.spacingLg,
      );
    }

    return Row(
      children: [
        Expanded(child: Divider(color: lineColor, thickness: AppDimensions.borderHair)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
          child: Text(label!, style: AppTextStyles.labelMuted),
        ),
        Expanded(child: Divider(color: lineColor, thickness: AppDimensions.borderHair)),
      ],
    );
  }
}
