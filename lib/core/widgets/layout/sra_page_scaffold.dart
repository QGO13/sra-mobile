import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Scaffold de page SRA Hotel — fond cohérent, AppBar, padding uniforme.
///
/// Toutes les pages doivent utiliser ce scaffold (ou équivalent) en lieu et
/// place d'un Scaffold nu, afin d'assurer le fond, les paddings et l'AppBar
/// uniformes sur toute l'application.
///
/// ```dart
/// SraPageScaffold(
///   title: 'Chambres',
///   body: ListView(...),
/// )
/// SraPageScaffold.noPadding(
///   title: 'Détail chambre',
///   body: CustomScrollView(...),
/// )
/// ```
class SraPageScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool applyPadding;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final bool showAppBar;

  const SraPageScaffold({
    super.key,
    this.title,
    required this.body,
    this.applyPadding = true,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.showAppBar = true,
  });

  const SraPageScaffold.noPadding({
    Key? key,
    String? title,
    required Widget body,
    List<Widget>? actions,
    Widget? leading,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    bool showAppBar = true,
  }) : this(
          key: key,
          title: title,
          body: body,
          applyPadding: false,
          actions: actions,
          leading: leading,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          showAppBar: showAppBar,
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.fog,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      appBar: showAppBar && title != null
          ? AppBar(
              title: Text(
                title!,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark ? AppColors.gold : AppColors.ink,
                ),
              ),
              backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
              foregroundColor: isDark ? AppColors.gold : AppColors.ink,
              elevation: AppDimensions.cardElevation,
              centerTitle: false,
              leading: leading,
              actions: [
                ...?actions,
                const SizedBox(width: AppDimensions.spacingSm),
              ],
            )
          : null,
      body: applyPadding
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pagePaddingH,
                vertical: AppDimensions.pagePaddingV,
              ),
              child: body,
            )
          : body,
    );
  }
}
