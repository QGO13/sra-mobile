import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class SraInput extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final int maxLines;

  const SraInput({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.8,
              color: AppColors.champagneGold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: isDark ? Colors.white : AppColors.imperialNightBlue,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
            fillColor: isDark ? AppColors.deepBlue : Colors.white,
            filled: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : AppColors.softGrey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.champagneGold,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
          ),
        ),
      ],
    );
  }
}

