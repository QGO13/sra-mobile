import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

// =============================================================================
// SRA STATUS BADGE — Composant unifié (fusion de SraStatusBadge + StatusBadge)
//
// Aligne sur StatusPill.tsx de design_SRAh.
// Remplace entièrement status_badge.dart (supprimé du barrel).
// =============================================================================

/// Types sémantiques de statut supportés.
enum SraStatusType { success, error, warning, info, custom }

/// Badge de statut pill-shaped avec point indicateur coloré et support Dark Mode.
///
/// Usage rapide via named constructors :
/// ```dart
/// SraStatusBadge.success(label: 'Confirmé')
/// SraStatusBadge.error(label: 'Annulé')
/// SraStatusBadge.custom(label: 'Sélectionné', color: AppColors.gold)
/// ```
///
/// Rétro-compatibilité : utiliser [StatusBadge] pour les anciens appels
/// avec `color` directe.
class SraStatusBadge extends StatelessWidget {
  final String label;
  final SraStatusType type;
  final Color? customColor;

  /// Afficher le point indicateur
  final bool dot;

  /// Taille réduite (compact pill)
  final bool small;

  const SraStatusBadge({
    super.key,
    required this.label,
    this.type = SraStatusType.info,
    this.customColor,
    this.dot = true,
    this.small = false,
  });

  const SraStatusBadge.success({
    Key? key,
    required String label,
    bool dot = true,
    bool small = false,
  }) : this(key: key, label: label, type: SraStatusType.success, dot: dot, small: small);

  const SraStatusBadge.error({
    Key? key,
    required String label,
    bool dot = true,
    bool small = false,
  }) : this(key: key, label: label, type: SraStatusType.error, dot: dot, small: small);

  const SraStatusBadge.warning({
    Key? key,
    required String label,
    bool dot = true,
    bool small = false,
  }) : this(key: key, label: label, type: SraStatusType.warning, dot: dot, small: small);

  const SraStatusBadge.info({
    Key? key,
    required String label,
    bool dot = true,
    bool small = false,
  }) : this(key: key, label: label, type: SraStatusType.info, dot: dot, small: small);

  /// Named constructor pour couleur personnalisée directe.
  /// Remplace l'ancien [StatusBadge] qui acceptait une Color brute.
  const SraStatusBadge.custom({
    Key? key,
    required String label,
    required Color color,
    bool dot = true,
    bool small = false,
  }) : this(
         key: key,
         label: label,
         type: SraStatusType.custom,
         customColor: color,
         dot: dot,
         small: small,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _color;
    final double dotSize  = small ? AppDimensions.spacingSm : AppDimensions.spacingSm + AppDimensions.spacingXs;
    final double hPad     = small ? AppDimensions.spacingSm : AppDimensions.spacingMd;
    final double vPad     = small ? AppDimensions.spacingXs : AppDimensions.spacingXs + AppDimensions.borderMedium;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.20 : 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.45 : 0.30),
          width: AppDimensions.borderThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (dot) ...[
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            AppDimensions.hGapXs,
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

// =============================================================================
// StatusBadge — Alias rétro-compatible (NE PAS utiliser dans le nouveau code)
//
// Remplace l'ancien status_badge.dart. Accepte une Color directe comme avant.
// Migrer progressivement vers SraStatusBadge.custom(label:..., color:...).
// =============================================================================

/// @deprecated Utiliser [SraStatusBadge.custom] dans le nouveau code.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return SraStatusBadge.custom(
      label: label,
      color: color,
      small: small,
    );
  }
}
