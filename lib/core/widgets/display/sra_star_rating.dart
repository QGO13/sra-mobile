import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Affichage d'étoiles d'évaluation SRA Hotel — étoiles dorées avec support Dark Mode.
class SraStarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final int? reviewCount;

  const SraStarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = AppDimensions.iconSizeSm,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxStars, (index) {
            final starValue = index + 1;
            IconData iconData;
            if (rating >= starValue) {
              iconData = Icons.star_rounded;
            } else if (rating >= starValue - 0.5) {
              iconData = Icons.star_half_rounded;
            } else {
              iconData = Icons.star_outline_rounded;
            }

            return Icon(
              iconData,
              size: size,
              color: AppColors.gold,
            );
          }),
        ),
        if (reviewCount != null) ...[
          AppDimensions.hGapXs,
          Text(
            '($reviewCount)',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
              fontSize: size * 0.75,
            ),
          ),
        ],
      ],
    );
  }
}
