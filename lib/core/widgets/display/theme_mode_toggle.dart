import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Composant réutilisable de bascule de thème clair/sombre.
///
/// Équivalent de `ThemeModeToggle.tsx` dans le design V2.
class ThemeModeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onToggle;

  const ThemeModeToggle({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isDark ? 'Mode clair' : 'Mode sombre',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
        child: Icon(
          isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          key: ValueKey<bool>(isDark),
          color: isDark ? AppColors.goldLight2 : AppColors.gold,
        ),
      ),
      onPressed: () => onToggle(!isDark),
    );
  }
}
