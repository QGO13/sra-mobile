import 'package:flutter/material.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Centred, premium error-state view displayed when a data-fetch or operation fails.
/// Catégorise les erreurs (connexion, serveur, inattendue) pour rassurer l'utilisateur.
///
/// Usage:
/// ```dart
/// ErrorStateView(
///   message: 'Impossible de charger les réservations.',
///   onRetry: () => context.read<BookingBloc>().add(const BookingFetchRequested()),
/// )
/// ```
class ErrorStateView extends StatelessWidget {
  /// Raw error message/exception string.
  final String message;

  /// Optional callback that powers the retry [SraButton].
  /// When null, the button is not rendered.
  final VoidCallback? onRetry;

  /// Optional label for the retry button. If null, uses the localized retry string.
  final String? retryLabel;

  const ErrorStateView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final errorIcon = ErrorMapper.getIcon(message);
    final errorTitle = ErrorMapper.getTitle(message, l10n);
    final errorSubtitle = ErrorMapper.getSubtitle(message, l10n);
    final isConnectionError = ErrorMapper.getErrorType(message) == ErrorType.connection;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingXl,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 350),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1.0 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon Container with subtle glow/background ──────────────
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                decoration: BoxDecoration(
                  color: isConnectionError
                      ? AppColors.gold.withValues(alpha: 0.08)
                      : AppColors.statusError.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  errorIcon,
                  size: 56.0,
                  color: isConnectionError
                      ? AppColors.gold
                      : AppColors.statusError,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd + 4),
              // ── Title ─────────────────────────────────────────────────────
              Text(
                errorTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge.copyWith(
                  color: isDark ? AppColors.white : AppColors.ink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              // ── Subtitle / Details ────────────────────────────────────────
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  errorSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.overlayDarkMedium : AppColors.ink,
                    height: 1.45,
                  ),
                ),
              ),
              // ── Retry button ──────────────────────────────────────────────
              if (onRetry != null) ...[
                const SizedBox(height: AppDimensions.spacingLg),
                isConnectionError
                    ? SraButton.secondary(
                        onPressed: onRetry,
                        label: retryLabel ?? l10n.errorRetryButton,
                      )
                    : SraButton.danger(
                        onPressed: onRetry,
                        label: retryLabel ?? l10n.errorRetryButton,
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
