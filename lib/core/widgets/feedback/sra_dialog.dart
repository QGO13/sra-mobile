import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';

/// Boîte de dialogue modale SRA Hotel — style luxe avec support dark mode.
class SraDialog extends StatelessWidget {
  final String title;
  final String content;
  final String primaryButtonLabel;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;
  final IconData? icon;
  final bool isDanger;

  const SraDialog({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonLabel,
    required this.onPrimaryPressed,
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
    this.icon,
    this.isDanger = false,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    required String primaryButtonLabel,
    required VoidCallback onPrimaryPressed,
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryPressed,
    IconData? icon,
    bool isDanger = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => SraDialog(
        title: title,
        content: content,
        primaryButtonLabel: primaryButtonLabel,
        onPrimaryPressed: onPrimaryPressed,
        secondaryButtonLabel: secondaryButtonLabel,
        onSecondaryPressed: onSecondaryPressed,
        icon: icon,
        isDanger: isDanger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: AppDimensions.avatarSizeLg,
                height: AppDimensions.avatarSizeLg,
                decoration: BoxDecoration(
                  color: (isDanger ? AppColors.statusError : AppColors.gold)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconSizeXl,
                  color: isDanger ? AppColors.statusError : AppColors.gold,
                ),
              ),
              AppDimensions.vGapMd,
            ],
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: isDark ? AppColors.white : AppColors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            AppDimensions.vGapSm,
            Text(
              content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.overlayDarkMedium : AppColors.inkSoft,
              ),
              textAlign: TextAlign.center,
            ),
            AppDimensions.vGapXl,
            Row(
              children: [
                if (secondaryButtonLabel != null) ...[
                  Expanded(
                    child: SraButton.secondary(
                      label: secondaryButtonLabel!,
                      onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
                      small: true,
                    ),
                  ),
                  AppDimensions.hGapMd,
                ],
                Expanded(
                  child: isDanger
                      ? SraButton.danger(
                          label: primaryButtonLabel,
                          onPressed: () {
                            Navigator.of(context).pop();
                            onPrimaryPressed();
                          },
                          small: true,
                        )
                      : SraButton(
                          label: primaryButtonLabel,
                          onPressed: () {
                            Navigator.of(context).pop();
                            onPrimaryPressed();
                          },
                          small: true,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
