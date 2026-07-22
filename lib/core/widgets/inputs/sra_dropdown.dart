import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Champ déroulant SRA Hotel avec support Dark Mode et 6 règles strictes.
class SraDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final List<String> items;
  final Map<String, String>? itemLabels;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  const SraDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.items,
    this.itemLabels,
    this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelUppercase,
        ),
        AppDimensions.vGapSm,
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          validator: validator,
          dropdownColor: isDark ? AppColors.darkCard : AppColors.white,
          menuMaxHeight: AppDimensions.responsiveCardMaxExtent,
          iconEnabledColor: AppColors.gold,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.white : AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.inkMuted,
            ),
            fillColor: isDark ? AppColors.darkCard : AppColors.white,
            filled: true,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingMd,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.mist,
                width: AppDimensions.borderThin,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.gold,
                width: AppDimensions.borderMedium,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.statusError,
                width: AppDimensions.borderThin,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.statusError,
                width: AppDimensions.borderMedium,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
          ),
          items: items.map((item) {
            final displayText = itemLabels != null ? (itemLabels![item] ?? item) : item;
            return DropdownMenuItem<String>(
              value: item,
              child: Text(displayText),
            );
          }).toList(),
        ),
      ],
    );
  }
}
