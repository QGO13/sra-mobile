import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Modal confirmation dialog for destructive actions (delete, remove, etc.).
///
/// Returns `true` when the user confirms, `false` when they cancel or
/// dismiss the dialog.
///
/// Usage:
/// ```dart
/// final confirmed = await ConfirmDeleteDialog.show(
///   context,
///   title: 'Supprimer la réservation',
///   message: 'Cette action est irréversible. Voulez-vous continuer ?',
/// );
/// if (confirmed) { ... }
/// ```
class ConfirmDeleteDialog {
  // Private constructor — only the static [show] factory is public.
  const ConfirmDeleteDialog._();

  /// Shows a confirmation [AlertDialog] and returns `true` if the user
  /// pressed the destructive action button, `false` otherwise.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.deepBlue : AppColors.surfaceLight,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          // ── Title ──────────────────────────────────────────────────────
          title: Text(
            title,
            style: AppTextStyles.titleMedium,
          ),
          // ── Body ───────────────────────────────────────────────────────
          content: Text(
            message,
            style: AppTextStyles.bodyMedium,
          ),
          // ── Actions ────────────────────────────────────────────────────
          actions: [
            // Cancel — neutral / muted style
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                cancelLabel ?? 'Annuler',
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
            // Confirm — destructive or accent style
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                confirmLabel ?? (isDestructive ? 'Supprimer' : 'Confirmer'),
                style: AppTextStyles.buttonLabel.copyWith(
                  color: isDestructive ? AppColors.statusError : AppColors.champagneGold,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If the dialog is dismissed by tapping the barrier, result is null → false.
    return result ?? false;
  }
}
