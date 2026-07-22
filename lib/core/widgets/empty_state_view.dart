import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Centred empty-state placeholder displayed when a list or section has no data.
/// Uses localized fallbacks if no specific title/subtitle is provided.
///
/// Usage:
/// ```dart
/// EmptyStateView(
///   title: 'Aucune réservation',
///   subtitle: 'Les réservations à venir apparaîtront ici.',
///   actionLabel: 'Nouvelle réservation',
///   onAction: () => context.push('/bookings/new'),
/// )
/// ```
class EmptyStateView extends StatelessWidget {
  /// Icon rendered inside the gold circle. Defaults to [Icons.inbox_outlined].
  final IconData icon;

  /// Optional primary message. If null, defaults to localized "Aucune donnée disponible".
  final String? title;

  /// Optional secondary description. If null, defaults to localized "Il n'y a rien à afficher pour le moment."
  final String? subtitle;

  /// Label for the optional call-to-action [SraButton].
  final String? actionLabel;

  /// Callback for the optional call-to-action button.
  /// Both [actionLabel] and [onAction] must be non-null for the button to appear.
  final VoidCallback? onAction;

  /// Whether the CTA button should be outlined (default) or solid gold.
  final bool isOutlined;

  const EmptyStateView({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.isOutlined = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final displayTitle = title ?? l10n.emptyStateDefaultTitle;
    final displaySubtitle = subtitle ?? l10n.emptyStateDefaultSubtitle;
    final bool showButton = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingXl,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1.0 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon Container (Gold themed like cart page) ─────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.champagneGold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30.0,
                  color: AppColors.champagneGold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              // ── Title ─────────────────────────────────────────────────────
              Text(
                displayTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark ? AppColors.ecruWhite : AppColors.imperialNightBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              // ── Subtitle ──────────────────────────────────────────────────
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  displaySubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textMuted : AppColors.imperialNightBlue.withValues(alpha: 0.54),
                    height: 1.6,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              // ── CTA button ────────────────────────────────────────────────
              if (showButton) ...[
                const SizedBox(height: AppDimensions.spacingXl),
                SraButton(
                  onPressed: onAction,
                  label: actionLabel!,
                  isOutlined: isOutlined,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
