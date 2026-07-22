import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class SraLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const SraLogo({
    super.key,
    double? size,
    double? height,
    this.iconSize = 60.0,
  }) : size = size ?? height ?? 120.0;

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
                  style: GoogleFonts.cormorantGaramond(
                    color: AppColors.white,
                    fontSize: size * 0.3,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "SWEET • REST",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "APARTHOTEL",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3.0,
                  color: isDark ? AppColors.overlayDarkMedium : AppColors.ink.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rate_rounded, color: AppColors.gold, size: 10),
                  SizedBox(width: 4),
                  Icon(Icons.star_rate_rounded, color: AppColors.gold, size: 10),
                  SizedBox(width: 4),
                  Icon(Icons.star_rate_rounded, color: AppColors.gold, size: 10),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

