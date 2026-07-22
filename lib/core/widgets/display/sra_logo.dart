import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Logo officiel SRA Hotel avec fallback typographique Or (Playfair Display) et support Dark Mode.
class SraLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const SraLogo({
    super.key,
    double? size,
    double? height,
    this.iconSize = AppDimensions.avatarSizeLg,
  }) : size = size ?? height ?? AppDimensions.logoSize * 1.5;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Image.network(
        "https://sra-hotel.com/media/logo-SweetRestAparthotel_color.png",
        width: size * 1.5,
        height: size * 0.5,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "SR",
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.white,
                    fontSize: size * 0.3,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              AppDimensions.vGapSm,
              Text(
                "SWEET • REST",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: AppColors.gold,
                ),
              ),
              AppDimensions.vGapXs,
              Text(
                "APARTHOTEL",
                style: AppTextStyles.labelUppercase.copyWith(
                  letterSpacing: 3.0,
                  color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                ),
              ),
              AppDimensions.vGapXs,
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rate_rounded, color: AppColors.gold, size: AppDimensions.iconSizeSm),
                  AppDimensions.hGapXs,
                  Icon(Icons.star_rate_rounded, color: AppColors.gold, size: AppDimensions.iconSizeSm),
                  AppDimensions.hGapXs,
                  Icon(Icons.star_rate_rounded, color: AppColors.gold, size: AppDimensions.iconSizeSm),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
