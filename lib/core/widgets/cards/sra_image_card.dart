import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Carte avec image hero, dégradé sombre et contenu en overlay.
class SraImageCard extends StatelessWidget {
  final String imageUrl;
  final double height;
  final Widget? overlayContent;
  final Widget? badge;
  final VoidCallback? onTap;
  final double borderRadius;

  const SraImageCard({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.overlayContent,
    this.badge,
    this.onTap,
    this.borderRadius = AppDimensions.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: isDark ? AppColors.darkElevated : AppColors.mist,
        boxShadow: const [AppShadows.card],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: isDark ? AppColors.darkElevated : AppColors.mist,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.inkMuted,
                    size: AppDimensions.iconSizeXl,
                  ),
                ),
              ),
            ),
            // Dégradé sombre bas pour lisibilité
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00000000),
                    Color(0xCC000000),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                top: AppDimensions.spacingMd,
                right: AppDimensions.spacingMd,
                child: badge!,
              ),
            if (overlayContent != null)
              Positioned(
                bottom: AppDimensions.spacingMd,
                left: AppDimensions.spacingMd,
                right: AppDimensions.spacingMd,
                child: overlayContent!,
              ),
          ],
        ),
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}
