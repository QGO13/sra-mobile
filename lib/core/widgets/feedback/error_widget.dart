import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';

/// Widget d'erreur SRA Hotel — icône, message, retry optionnel avec support Dark Mode.
class SraErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String retryLabel;

  const SraErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryLabel = 'Réessayer',
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
          children: [
            // ── Icône erreur ──────────────────────────────────────────────
            Container(
              width: AppDimensions.avatarSizeLg,
              height: AppDimensions.avatarSizeLg,
              decoration: BoxDecoration(
                color: AppColors.statusError.withValues(alpha: isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.statusError,
                size: AppDimensions.iconSizeXl,
              ),
            ),
            AppDimensions.vGapMd,
            // ── Titre ─────────────────────────────────────────────────────
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.titleSmall.copyWith(
                  color: isDark ? AppColors.white : AppColors.ink,
                ),
                textAlign: TextAlign.center,
              ),
              AppDimensions.vGapXs,
            ],
            // ── Message ───────────────────────────────────────────────────
            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
              ),
              textAlign: TextAlign.center,
            ),
            // ── Bouton retry ──────────────────────────────────────────────
            if (onRetry != null) ...[
              AppDimensions.vGapLg,
              SraButton.secondary(
                label: retryLabel,
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
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
