import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Modal confirmation dialog for destructive actions (delete, remove, etc.) avec support Dark Mode.
class ConfirmDeleteDialog {
  const ConfirmDeleteDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = true,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.mist,
              width: AppDimensions.borderThin,
            ),
          ),
          // ── Title ──────────────────────────────────────────────────────
          title: Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.ink,
            ),
          ),
          // ── Body ───────────────────────────────────────────────────────
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkSoft,
            ),
          ),
          // ── Actions ────────────────────────────────────────────────────
          actions: [
            // Cancel — neutral / muted style
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                cancelLabel ?? 'Annuler',
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            // Confirm — destructive or accent style
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                confirmLabel ?? (isDestructive ? 'Supprimer' : 'Confirmer'),
                style: AppTextStyles.buttonLabel.copyWith(
                  color: isDestructive ? AppColors.statusError : AppColors.gold,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
