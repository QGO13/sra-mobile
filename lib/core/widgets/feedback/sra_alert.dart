import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

// =============================================================================
// SRA ALERT — Bannière d'alerte inline (équivalent MUI Alert)
//
// Aligné sur le composant `Alert` utilisé dans design_SRAh (LoginPage, OtpPage,
// ChangePasswordPage, LogoutPage). Remplace les Container ad-hoc des pages auth.
// =============================================================================

enum SraAlertType { success, error, warning, info }

class SraAlert extends StatelessWidget {
  final String message;
  final SraAlertType type;
  final IconData? icon;

  const SraAlert({
    super.key,
    required this.message,
    this.type = SraAlertType.info,
    this.icon,
  });

  const SraAlert.success({Key? key, required String message, IconData? icon})
      : this(key: key, message: message, type: SraAlertType.success, icon: icon);

  const SraAlert.error({Key? key, required String message, IconData? icon})
      : this(key: key, message: message, type: SraAlertType.error, icon: icon);

  const SraAlert.warning({Key? key, required String message, IconData? icon})
      : this(key: key, message: message, type: SraAlertType.warning, icon: icon);

  const SraAlert.info({Key? key, required String message, IconData? icon})
      : this(key: key, message: message, type: SraAlertType.info, icon: icon);

  Color get _color {
    switch (type) {
      case SraAlertType.success: return AppColors.statusSuccess;
      case SraAlertType.error:   return AppColors.statusError;
      case SraAlertType.warning: return AppColors.statusWarning;
      case SraAlertType.info:    return AppColors.statusInfo;
    }
  }

  IconData get _defaultIcon {
    switch (type) {
      case SraAlertType.success: return Icons.check_circle_outline_rounded;
      case SraAlertType.error:   return Icons.error_outline_rounded;
      case SraAlertType.warning: return Icons.warning_amber_rounded;
      case SraAlertType.info:    return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.45 : 0.30),
          width: AppDimensions.borderThin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? _defaultIcon, color: color, size: AppDimensions.iconSizeMd),
          AppDimensions.hGapSm,
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
