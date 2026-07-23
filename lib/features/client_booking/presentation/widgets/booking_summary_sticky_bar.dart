import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Barre fixe de résumé du séjour et validation au bas de la page — Reproduction de `BookingPage.tsx`.
class BookingSummaryStickyBarWidget extends StatelessWidget {
  final String roomName;
  final int nights;
  final int guests;
  final int totalAmount;
  final int activeStep;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const BookingSummaryStickyBarWidget({
    super.key,
    required this.roomName,
    required this.nights,
    required this.guests,
    required this.totalAmount,
    required this.activeStep,
    required this.onNext,
    this.onBack,
  });

  String _formatFcfa(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;

    final nightsStr = l10n.nightsCount(nights);
    final guestsStr = guests > 1 ? l10n.guestsCountPlural(guests) : l10n.guestsCountSingular(guests);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingMd,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: cardBorder, width: AppDimensions.borderThin),
        boxShadow: const [AppShadows.card],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Récapitulatif Gauche : Chambre, nuits & total ──
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$roomName · $nightsStr · $guestsStr',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: textMuted,
                  ),
                ),
                AppDimensions.vGapXs,
                Text(
                  _formatFcfa(totalAmount),
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.gold,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // ── Boutons d'action Droite : Retour & Continuer / Payer ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activeStep > 0 && onBack != null) ...[
                OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: AppDimensions.iconSizeSm),
                  label: Text(l10n.cancelLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.white : AppColors.ink,
                    side: BorderSide(color: cardBorder),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMd,
                      vertical: AppDimensions.spacingMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                  ),
                ),
                AppDimensions.hGapSm,
              ],

              SraButton(
                fullWidth: false,
                label: l10n.addToCartUpperButton,
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
