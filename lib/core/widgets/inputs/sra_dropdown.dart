import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

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
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          validator: validator,
          dropdownColor: isDark ? AppColors.ink : AppColors.white,
          menuMaxHeight: 300,
          iconEnabledColor: AppColors.gold,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: isDark ? AppColors.white : AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: isDark ? AppColors.white38 : Colors.black38,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
            fillColor: isDark ? AppColors.darkCard : AppColors.white,
            filled: true,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? AppColors.white12 : AppColors.mist,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.gold,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.statusError,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.statusError,
                width: 1.2,
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
