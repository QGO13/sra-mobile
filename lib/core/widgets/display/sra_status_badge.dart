import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Badge de statut SRA Hotel — affichage sémantique cohérent.
///
/// ```dart
/// SraStatusBadge.success(label: 'Payé')
/// SraStatusBadge.error(label: 'Annulé')
/// SraStatusBadge.warning(label: 'En attente')
/// SraStatusBadge.info(label: 'Confirmé')
/// SraStatusBadge.custom(label: 'À nettoyer', color: AppColors.statusToClean)
/// ```
enum SraStatusType { success, error, warning, info, custom }

class SraStatusBadge extends StatelessWidget {
  final String label;
  final SraStatusType type;
  final Color? customColor;
  final bool dot;

  const SraStatusBadge({
    super.key,
    required this.label,
    this.type = SraStatusType.info,
    this.customColor,
    this.dot = true,
  });

  const SraStatusBadge.success({Key? key, required String label, bool dot = true})
      : this(key: key, label: label, type: SraStatusType.success, dot: dot);

  const SraStatusBadge.error({Key? key, required String label, bool dot = true})
      : this(key: key, label: label, type: SraStatusType.error, dot: dot);

  const SraStatusBadge.warning({Key? key, required String label, bool dot = true})
      : this(key: key, label: label, type: SraStatusType.warning, dot: dot);

  const SraStatusBadge.info({Key? key, required String label, bool dot = true})
      : this(key: key, label: label, type: SraStatusType.info, dot: dot);

  const SraStatusBadge.custom({
    Key? key,
    required String label,
    required Color color,
    bool dot = true,
  }) : this(
          key: key,
          label: label,
          type: SraStatusType.custom,
          customColor: color,
          dot: dot,
        );

  Color get _color {
    switch (type) {
      case SraStatusType.success: return AppColors.statusSuccess;
      case SraStatusType.error:   return AppColors.statusError;
      case SraStatusType.warning: return AppColors.statusWarning;
      case SraStatusType.info:    return AppColors.statusInfo;
      case SraStatusType.custom:  return customColor ?? AppColors.inkMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: AppDimensions.spacingSm,
              height: AppDimensions.spacingSm,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppDimensions.spacingXs),
          ],
          Text(
            label,
            style: AppTextStyles.labelNormal.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
