import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// ListTile SRA Hotel — style luxe avec conteneur doré pour l'icône.
class SraListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SraListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leadingWidget,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? leading = leadingWidget;
    if (leading == null && leadingIcon != null) {
      leading = Container(
        width: AppDimensions.avatarSizeSm + 8,
        height: AppDimensions.avatarSizeSm + 8,
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: Icon(
          leadingIcon,
          color: AppColors.gold,
          size: AppDimensions.iconSizeMd,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
            vertical: AppDimensions.spacingXs,
          ),
          leading: leading,
          title: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.inkMuted,
                  ),
                )
              : null,
          trailing: trailing ??
              (onTap != null
                  ? const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.gold,
                      size: AppDimensions.iconSizeMd,
                    )
                  : null),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: AppDimensions.borderHair,
            color: isDark ? AppColors.darkBorder : AppColors.mist,
            indent: leading != null ? 64 : AppDimensions.spacingMd,
            endIndent: AppDimensions.spacingMd,
          ),
      ],
    );
  }
}
