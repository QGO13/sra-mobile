import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Section header avec titre Or uppercase, sous-titre optionnel, action et séparateur fin avec support Dark Mode.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Title row ───────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelUppercase,
                  ),
                  if (subtitle != null) ...[
                    AppDimensions.vGapXs,
                    Text(
                      subtitle!,
                      style: AppTextStyles.labelMuted.copyWith(
                        color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...[action!],
          ],
        ),
        // ── Divider ─────────────────────────────────────────────────────
        AppDimensions.vGapSm,
        Divider(
          color: isDark ? AppColors.darkBorder : AppColors.mist,
          thickness: AppDimensions.borderThin,
          height: AppDimensions.borderThin,
        ),
      ],
    );
  }
}
