import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Widget de chargement SRA Hotel — spinner doré avec label optionnel.
///
/// ```dart
/// const LoadingWidget()
/// const LoadingWidget(label: 'Chargement des chambres...')
/// const LoadingWidget.overlay()   // superposé sur la page
/// ```
class LoadingWidget extends StatelessWidget {
  final String? label;
  final bool overlay;

  const LoadingWidget({super.key, this.label, this.overlay = false});

  const LoadingWidget.overlay({Key? key, String? label})
      : this(key: key, label: label, overlay: true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Spinner doré ──────────────────────────────────────────────────
        SizedBox(
          width: AppDimensions.loadingIcon,
          height: AppDimensions.loadingIcon,
          child: Image.asset(
            "assets/images/logo.gif",
          ),
        ),
        // ── Label ─────────────────────────────────────────────────────────
        if (label != null) ...[
          AppDimensions.vGapMd,
          Text(
            label!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!overlay) {
      return Center(
        child: Padding(
          padding: AppDimensions.paddingXlAll,
          child: content,
        ),
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.85),
      child: Center(child: content),
    );
  }
}
