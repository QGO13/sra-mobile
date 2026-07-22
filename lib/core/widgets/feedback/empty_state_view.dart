import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';

/// Vue d'état vide Luxe ("Gold Empty State") — Icône Or, titre, sous-titre et action optionnelle.
///
/// Alignée sur `GoldEmptyState.tsx` de design SRAh avec support Dark Mode.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    required this.icon,
    this.title = '',
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pagePaddingH,
          vertical: AppDimensions.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Icône dans cercle Or avec double bordure luxe ─────────────
            Container(
              width: AppDimensions.logoSize,
              height: AppDimensions.logoSize,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: isDark ? 0.6 : 0.4),
                  width: AppDimensions.borderMedium,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: AppDimensions.iconSizeXl,
                  color: AppColors.gold,
                ),
              ),
            ),
            AppDimensions.vGapLg,
            // ── Titre (Playfair Display) ──────────────────────────────────
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: isDark ? AppColors.white : AppColors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            // ── Sous-titre (Raleway) ─────────────────────────────────────
            if (subtitle != null) ...[
              AppDimensions.vGapSm,
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // ── Bouton d'action ──────────────────────────────────────────
            if (actionLabel != null && onAction != null) ...[
              AppDimensions.vGapXl,
              SraButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
                small: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
