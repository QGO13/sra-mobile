import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Champ de saisie SRA Hotel — zéro valeur codée en dur avec support Dark Mode.
///
/// ```dart
/// SraInput(controller: _ctrl, label: 'Email', placeholder: 'contact@email.com')
/// SraInput(controller: _ctrl, label: 'Mot de passe', obscureText: true)
/// SraInput(controller: _ctrl, label: 'Message', maxLines: 4)
/// ```
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
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final String? helperText;

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
    this.onSubmitted,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label uppercase or ──────────────────────────────────────────────
        if (label != null) ...[
          Text(label!.toUpperCase(), style: AppTextStyles.labelUppercase),
          AppDimensions.vGapSm,
        ],
        // ── Champ de saisie ─────────────────────────────────────────────────
        TextFormField(
          controller:          controller,
          obscureText:         obscureText,
          validator:           validator,
          keyboardType:        keyboardType,
          readOnly:            readOnly,
          onTap:               onTap,
          onChanged:           onChanged,
          onFieldSubmitted:    onSubmitted,
          maxLines:            obscureText ? 1 : maxLines,
          maxLength:           maxLength,
          inputFormatters:     inputFormatters,
          focusNode:           focusNode,
          autofocus:           autofocus,
          textCapitalization:  textCapitalization,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.white : AppColors.ink,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText:   placeholder,
            hintStyle:  AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
              fontWeight: FontWeight.w400,
            ),
            filled:     true,
            fillColor:  isDark ? AppColors.darkCard : AppColors.white,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: '',
            helperText: helperText,
            helperStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.inkMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical:   AppDimensions.spacingMd,
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
            errorStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.statusError,
            ),
          ),
        ),
      ],
    );
  }
}
