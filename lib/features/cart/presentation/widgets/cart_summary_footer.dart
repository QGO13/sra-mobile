import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class CartSummaryFooter extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final double selectedSubtotal;
  final VoidCallback? onProceedToBooking;
  final VoidCallback onAddMoreRooms;

  const CartSummaryFooter({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.selectedSubtotal,
    required this.onProceedToBooking,
    required this.onAddMoreRooms,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.overlayDark : AppColors.softGrey,
            width: AppDimensions.borderThin,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.cartSummaryTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark ? AppColors.ecruWhite : AppColors.imperialNightBlue,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm + 6),
              _buildSummaryRow(
                l10n.selectedAccommodations,
                "$selectedCount / $totalCount",
                isDark,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _buildSummaryRow(
                l10n.governance,
                l10n.freeBreakfastIncluded,
                isDark,
              ),
              const Divider(height: AppDimensions.spacingLg, thickness: 0.5, color: AppColors.softGrey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.totalAmount,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${selectedSubtotal.toStringAsFixed(0)} FCFA",
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.champagneGold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.taxesIncludedNote,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg - 4),
              SraButton(
                onPressed: onProceedToBooking,
                label: selectedCount > 0
                    ? l10n.proceedToBooking(selectedCount)
                    : l10n.selectAtLeastOneRoom,
              ),
              const SizedBox(height: AppDimensions.spacingSm + 2),
              SraButton(
                onPressed: onAddMoreRooms,
                label: l10n.addMoreRooms,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.ecruWhite.withValues(alpha: 0.7) : AppColors.imperialNightBlue,
          ),
        ),
      ],
    );
  }
}
