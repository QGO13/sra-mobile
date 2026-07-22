import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Widget état vide SRA Hotel — icône, titre, sous-titre, action optionnelle.
///
/// ```dart
/// EmptyStateView(
///   icon: Icons.hotel_outlined,
///   title: 'Aucune chambre',
///   subtitle: 'Aucune chambre ne correspond à vos critères.',
/// )
/// EmptyStateView(
///   icon: Icons.receipt_long_outlined,
///   title: 'Aucune réservation',
///   actionLabel: 'Réserver maintenant',
///   onAction: () => context.go('/rooms'),
/// )
/// ```
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pagePaddingH,
          vertical: AppDimensions.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icône dans cercle doré semi-transparent ───────────────────
            Container(
              width: AppDimensions.avatarSizeLg + AppDimensions.spacingLg,
              height: AppDimensions.avatarSizeLg + AppDimensions.spacingLg,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  width: AppDimensions.borderThin,
                ),
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconSizeXl,
                color: AppColors.gold.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            // ── Titre ─────────────────────────────────────────────────────
            Text(
              title,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            // ── Sous-titre ────────────────────────────────────────────────
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                subtitle!,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            // ── Action ────────────────────────────────────────────────────
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spacingXl),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.white,
                    elevation: AppDimensions.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                  ),
                  child: Text(
                    actionLabel!.toUpperCase(),
                    style: AppTextStyles.buttonLabelSm.copyWith(
                      color: AppColors.white,
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
