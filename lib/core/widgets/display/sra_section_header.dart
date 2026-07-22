import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// En-tête de section SRA Hotel — titre Playfair + label uppercase or + action avec support Dark Mode.
class SraSectionHeader extends StatelessWidget {
  final String? label;
  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  final EdgeInsetsGeometry? padding;

  const SraSectionHeader({
    super.key,
    required this.title,
    this.label,
    this.subtitle,
    this.trailingLabel,
    this.onTrailingTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Label uppercase doré ──────────────────────────────────
                if (label != null) ...[
                  Text(label!.toUpperCase(), style: AppTextStyles.labelUppercase),
                  AppDimensions.vGapXs,
                ],
                // ── Titre Playfair Display ────────────────────────────────
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
                // ── Sous-titre optionnel ──────────────────────────────────
                if (subtitle != null) ...[
                  AppDimensions.vGapXs,
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // ── Action trailing ───────────────────────────────────────────
          if (trailingLabel != null && onTrailingTap != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailingLabel!,
                    style: AppTextStyles.labelNormal.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                  AppDimensions.hGapXs,
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
