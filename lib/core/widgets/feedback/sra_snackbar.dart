import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Helper SnackBar SRA Hotel — toast uniforme, zéro valeur codée en dur.
enum SraSnackbarType { success, error, warning, info }

class SraSnackbar {
  SraSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SraSnackbarType type = SraSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Color accentColor;
    IconData icon;
    switch (type) {
      case SraSnackbarType.success:
        accentColor = AppColors.statusSuccess;
        icon = Icons.check_circle_outline_rounded;
        break;
      case SraSnackbarType.error:
        accentColor = AppColors.statusError;
        icon = Icons.error_outline_rounded;
        break;
      case SraSnackbarType.warning:
        accentColor = AppColors.statusWarning;
        icon = Icons.warning_amber_rounded;
        break;
      case SraSnackbarType.info:
        accentColor = AppColors.gold;
        icon = Icons.info_outline_rounded;
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkElevated : AppColors.darkCard;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            side: BorderSide(
              color: accentColor.withValues(alpha: 0.4),
              width: AppDimensions.borderThin,
            ),
          ),
          margin: const EdgeInsets.all(AppDimensions.spacingMd),
          content: Row(
            children: [
              Icon(icon, color: accentColor, size: AppDimensions.iconSizeMd),
              AppDimensions.hGapMd,
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          action: actionLabel != null && onAction != null
              ? SnackBarAction(
                  label: actionLabel.toUpperCase(),
                  textColor: accentColor,
                  onPressed: onAction,
                )
              : null,
        ),
      );
  }
}
