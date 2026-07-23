import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';

/// Sélecteur de méthode de paiement (Mobile Money & Carte) — Reproduction Pixel-Perfect de `BookingPage.tsx`.
class PaymentMethodSelectorWidget extends StatelessWidget {
  final String selectedPayment;
  final ValueChanged<String> onPaymentChanged;
  final TextEditingController inputController;
  final bool hasError;

  const PaymentMethodSelectorWidget({
    super.key,
    required this.selectedPayment,
    required this.onPaymentChanged,
    required this.inputController,
    required this.hasError,
  });

  static const paymentOptions = [
    'MTN Money',
    'Orange Money',
    'Moov Money',
    'Wave',
    'Carte bancaire',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final isCard = selectedPayment == 'Carte bancaire';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Liste des options de paiement ──
        Column(
          children: paymentOptions.map((option) {
            final isSelected = selectedPayment == option;
            final isWave = option == 'Wave';
            final isMobile = option != 'Carte bancaire';

            final cardBg = isSelected
                ? AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.08)
                : (isDark ? AppColors.darkCard : AppColors.white);
            final cardBorder = isSelected
                ? AppColors.gold
                : (isDark ? AppColors.darkBorder : AppColors.mist);

            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: InkWell(
                onTap: () => onPaymentChanged(option),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd,
                    vertical: AppDimensions.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(
                      color: cardBorder,
                      width: isSelected ? AppDimensions.borderMedium : AppDimensions.borderThin,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? AppColors.gold : textMuted,
                        size: AppDimensions.iconSizeMd,
                      ),
                      AppDimensions.hGapSm,
                      Icon(
                        isMobile
                            ? Icons.phone_iphone_rounded
                            : Icons.credit_card_rounded,
                        color: AppColors.gold,
                        size: AppDimensions.iconSizeMd,
                      ),
                      AppDimensions.hGapSm,
                      Text(
                        option,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.ink,
                        ),
                      ),
                      if (isWave) ...[
                        const Spacer(),
                        const StatusBadge(
                          label: "Sans frais",
                          color: AppColors.statusSuccess,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        AppDimensions.vGapLg,

        // ── Champ de saisie spécifique (Téléphone ou N° de carte) ──
        SraInput(
          label: isCard ? "NUMÉRO DE CARTE BANCAIRE *" : "NUMÉRO MOBILE MONEY *",
          placeholder: isCard ? "0000 0000 0000 0000" : "07 00 00 00 00",
          controller: inputController,
          keyboardType: isCard ? TextInputType.number : TextInputType.phone,
          prefixIcon: Icon(
            isCard ? Icons.credit_card_rounded : Icons.phone_iphone_rounded,
            color: AppColors.gold,
            size: AppDimensions.iconSizeMd,
          ),
        ),

        if (hasError) ...[
          AppDimensions.vGapXs,
          Text(
            isCard
                ? 'Saisissez un numéro de carte valide à 12 chiffres minimum.'
                : 'Saisissez un numéro de téléphone valide à 8 chiffres minimum.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.statusError,
            ),
          ),
        ] else ...[
          AppDimensions.vGapXs,
          Text(
            isCard
                ? 'Paiement chiffré et sécurisé SSL 256-bit.'
                : 'Une demande de validation vous sera envoyée via $selectedPayment.',
            style: AppTextStyles.bodySmall.copyWith(
              color: textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
