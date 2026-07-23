import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class CartHeaderBar extends StatelessWidget {
  final bool areAllSelected;
  final int selectedCount;
  final int totalCount;
  final ValueChanged<bool?> onToggleAll;

  const CartHeaderBar({
    super.key,
    required this.areAllSelected,
    required this.selectedCount,
    required this.totalCount,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : AppColors.softGrey,
            width: AppDimensions.borderThin,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: areAllSelected,
                    activeColor: AppColors.champagneGold,
                    onChanged: onToggleAll,
                  ),
                  Text(
                    l10n.selectAll,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.imperialNightBlue,
                    ),
                  ),
                ],
              ),
              Text(
                l10n.selectedRoomsCount(selectedCount, totalCount),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.champagneGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
