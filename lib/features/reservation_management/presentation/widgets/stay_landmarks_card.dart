import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Carte Vos Repères & Services — Reproduction Pixel-Perfect de `MyStayPage.tsx`.
class StayLandmarksCard extends StatelessWidget {
  const StayLandmarksCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourLandmarks,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.imperialNightBlue,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.yourLandmarksSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: textMuted,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          _LandmarkItem(
            icon: Icons.wifi_rounded,
            title: l10n.wifiLandmarkTitle,
            description: l10n.wifiLandmarkDesc,
          ),
          const Divider(height: 24, thickness: 0.5),
          _LandmarkItem(
            icon: Icons.directions_car_rounded,
            title: l10n.transferLandmarkTitle,
            description: l10n.transferLandmarkDesc,
          ),
          const Divider(height: 24, thickness: 0.5),
          _LandmarkItem(
            icon: Icons.room_service_rounded,
            title: l10n.roomServiceLandmarkTitle,
            description: l10n.roomServiceLandmarkDesc,
          ),
        ],
      ),
    );
  }
}

class _LandmarkItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _LandmarkItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.champagneGold, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isDark ? Colors.white : AppColors.imperialNightBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textMuted,
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
