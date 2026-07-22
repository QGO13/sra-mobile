import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/display/sra_logo.dart';

/// AppBar personnalisée SRA Hotel — style prestige avec support logo et dark mode.
class SraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final bool centerTitle;
  final Color? backgroundColor;

  const SraAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showLogo = false,
    this.centerTitle = false,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.white);

    return AppBar(
      title: titleWidget ??
          (showLogo
              ? const SraLogo(height: AppDimensions.iconSizeXl)
              : (title != null
                  ? Text(
                      title!,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isDark ? AppColors.gold : AppColors.ink,
                      ),
                    )
                  : null)),
      centerTitle: centerTitle,
      backgroundColor: bg,
      foregroundColor: isDark ? AppColors.gold : AppColors.ink,
      elevation: AppDimensions.cardElevation,
      leading: leading,
      actions: actions != null
          ? [...actions!, AppDimensions.hGapSm]
          : null,
    );
  }
}
