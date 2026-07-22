import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/cards/sra_card.dart';

/// Carte KPI Luxe — Affiche un indicateur de performance avec icône Or et tendance (% d'évolution).
///
/// Alignée Pixel Perfect sur `KpiCard.tsx` de design SRAh.
class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final double delta;
  final IconData icon;
  final String? comparisonPeriod;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.delta,
    required this.icon,
    this.comparisonPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUp = delta >= 0;
    final statusColor = isUp ? AppColors.statusSuccess : AppColors.statusError;
    final periodText = comparisonPeriod ?? 'vs. semaine dernière';

    return SraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: AppTextStyles.labelUppercase.copyWith(
                        color: isDark ? AppColors.goldLight2 : AppColors.gold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      value,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              AppDimensions.hGapSm,
              Container(
                width: AppDimensions.avatarSize,
                height: AppDimensions.avatarSize,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.14),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: AppDimensions.iconSizeLg,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          AppDimensions.vGapSm,
          Row(
            children: [
              Icon(
                isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: AppDimensions.iconSizeSm,
                color: statusColor,
              ),
              AppDimensions.hGapXs,
              Text(
                '${delta.abs().toStringAsFixed(1)}%',
                style: AppTextStyles.buttonLabelSm.copyWith(
                  color: statusColor,
                ),
              ),
              AppDimensions.hGapSm,
              Expanded(
                child: Text(
                  periodText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
