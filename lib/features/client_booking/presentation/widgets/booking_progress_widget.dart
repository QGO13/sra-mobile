import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Barre de progression du wizard de réservation — Reproduction Pixel-Perfect de `BookingProgress.tsx`.
class BookingProgressWidget extends StatelessWidget {
  final int activeStep;

  const BookingProgressWidget({
    super.key,
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = [l10n.bookingStepSelection, l10n.bookingStepCart];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final textActive = isDark ? AppColors.white : AppColors.ink;

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Ligne de connexion entre les étapes
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < activeStep;
            return Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.only(bottom: 20),
                color: isCompleted
                    ? AppColors.gold
                    : (isDark ? AppColors.darkBorder : AppColors.mist),
              ),
            );
          } else {
            // Puce d'étape (numéro + label)
            final stepIndex = index ~/ 2;
            final isActive = stepIndex <= activeStep;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.gold
                        : (isDark ? AppColors.darkCard : AppColors.white),
                    border: Border.all(
                      color: isActive
                          ? AppColors.gold
                          : (isDark ? AppColors.darkBorder : AppColors.mist),
                      width: AppDimensions.borderThin,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${stepIndex + 1}',
                    style: AppTextStyles.labelNormal.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColors.white
                          : textMuted,
                    ),
                  ),
                ),
                AppDimensions.vGapXs,
                Text(
                  steps[stepIndex],
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? textActive : textMuted,
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
