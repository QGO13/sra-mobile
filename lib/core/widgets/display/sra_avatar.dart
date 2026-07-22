import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Avatar SRA Hotel — initiales avec fond doré ou photo.
///
/// ```dart
/// SraAvatar(name: 'Jean Dupont')
/// SraAvatar(name: 'Marie', size: AppDimensions.avatarSizeLg)
/// SraAvatar(imageUrl: 'https://...', name: 'Admin')
/// ```
class SraAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const SraAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AppDimensions.avatarSizeMd,
    this.onTap,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: imageUrl == null ? AppColors.goldGradient : null,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
          width: AppDimensions.borderThin,
        ),
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                _initials,
                style: AppTextStyles.labelUppercase.copyWith(
                  color: AppColors.white,
                  fontSize: size * 0.34,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : null,
    );

    if (onTap == null) return avatar;

    return GestureDetector(onTap: onTap, child: avatar);
  }
}
