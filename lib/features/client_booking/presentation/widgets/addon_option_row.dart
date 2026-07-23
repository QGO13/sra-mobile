import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Ligne d'option additionnelle (Petit-déjeuner, lit d'appoint) — Reproduction de `AddonRow` dans `BookingPage.tsx`.
class AddonOptionRowWidget extends StatelessWidget {
  final String title;
  final String details;
  final bool value;
  final ValueChanged<bool> onChange;
  final bool disabled;

  const AddonOptionRowWidget({
    super.key,
    required this.title,
    required this.details,
    required this.value,
    required this.onChange,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final textTitle = disabled
        ? textMuted
        : (isDark ? AppColors.white : AppColors.ink);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textTitle,
                  ),
                ),
                AppDimensions.vGapXs,
                Text(
                  details,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          AppDimensions.hGapMd,
          Switch(
            value: value,
            activeThumbColor: AppColors.gold,
            onChanged: disabled ? null : onChange,
          ),
        ],
      ),
    );
  }
}
