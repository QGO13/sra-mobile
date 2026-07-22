import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Widget d'erreur SRA Hotel — icône, message, retry optionnel.
///
/// ```dart
/// SraErrorWidget(message: 'Connexion impossible')
/// SraErrorWidget(message: 'Erreur réseau', onRetry: () => bloc.retry())
/// ```
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
                color: AppColors.statusError.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.statusError,
                size: AppDimensions.iconSizeXl,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            // ── Titre ─────────────────────────────────────────────────────
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingXs),
            ],
            // ── Message ───────────────────────────────────────────────────
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            // ── Bouton retry ──────────────────────────────────────────────
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              SizedBox(
                width: 180,
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.gold,
                  ),
                  label: Text(
                    retryLabel.toUpperCase(),
                    style: AppTextStyles.buttonLabelSm.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(
                      color: AppColors.gold,
                      width: AppDimensions.borderMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
