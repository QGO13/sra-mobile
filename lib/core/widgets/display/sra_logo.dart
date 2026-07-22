import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Logo officiel SRA Hotel utilisant le vrai asset `assets/images/logo-SweetRestAparthotel_simple.png`.
class SraLogo extends StatelessWidget {
  final double size;
  final double iconSize;
  final bool simple;
  final bool colorLogo;

  const SraLogo({
    super.key,
    double? size,
    double? height,
    this.iconSize = AppDimensions.avatarSizeLg,
    this.simple = true,
    this.colorLogo = false,
  }) : size = size ?? height ?? AppDimensions.logoSize * 1.5;

  const SraLogo.simple({
    super.key,
    double? size,
    double? height,
  }) : size = size ?? height ?? AppDimensions.logoSize,
       iconSize = AppDimensions.avatarSizeLg,
       simple = true,
       colorLogo = false;

  const SraLogo.color({
    super.key,
    double? size,
    double? height,
  }) : size = size ?? height ?? AppDimensions.logoSize * 1.5,
       iconSize = AppDimensions.avatarSizeLg,
       simple = false,
       colorLogo = true;

  @override
  Widget build(BuildContext context) {
    final assetPath = simple
        ? 'assets/images/logo-SweetRestAparthotel_simple.png'
        : (colorLogo
            ? 'assets/images/logo-SweetRestAparthotel_color.png'
            : 'assets/images/logo-SweetRestAparthotel.png');

    return Center(
      child: Image.asset(
        assetPath,
        width: size * 1.5,
        height: size * 0.5,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.hotel_rounded,
            size: iconSize,
            color: AppColors.gold,
          );
        },
      ),
    );
  }
}
