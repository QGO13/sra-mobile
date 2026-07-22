import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Carte SRA Hotel — conteneur uniforme avec ombre, radius et padding gérés.
///
/// ```dart
/// SraCard(child: Text('Contenu'))
/// SraCard.flat(child: Text('Sans ombre'))
/// SraCard.gold(child: Text('Bordure or'))
/// ```
enum SraCardVariant { elevated, flat, gold }

class SraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final SraCardVariant variant;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const SraCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.variant = SraCardVariant.elevated,
    this.onTap,
    this.backgroundColor,
  });

  const SraCard.flat({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          variant: SraCardVariant.flat,
          onTap: onTap,
          backgroundColor: backgroundColor,
        );

  const SraCard.gold({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) : this(
          key: key,
          child: child,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          variant: SraCardVariant.gold,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppDimensions.radiusLg;
    final bg = backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.white);
    final effectivePadding = padding ??
        const EdgeInsets.symmetric(
          horizontal: AppDimensions.cardPaddingH,
          vertical: AppDimensions.cardPaddingV,
        );

    BoxDecoration decoration;
    switch (variant) {
      case SraCardVariant.elevated:
        decoration = BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [isDark
              ? const BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 16,
                )
              : AppShadows.card],
        );
        break;
      case SraCardVariant.flat:
        decoration = BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.mist,
            width: AppDimensions.borderThin,
          ),
        );
        break;
      case SraCardVariant.gold:
        decoration = BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.5),
            width: AppDimensions.borderMedium,
          ),
          boxShadow: [AppShadows.goldDisabled],
        );
        break;
    }

    final cardContent = Container(
      margin: margin,
      decoration: decoration,
      child: Padding(padding: effectivePadding, child: child),
    );

    if (onTap == null) return cardContent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: cardContent,
      ),
    );
  }
}
