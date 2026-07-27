import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/cards/sra_card.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';

class InventoryStatusCard extends StatelessWidget {
  final int availableRooms;
  final int roomsToPrepare;
  final int maintenanceRooms;
  final int totalRooms;

  const InventoryStatusCard({
    super.key,
    this.availableRooms = 18,
    this.roomsToPrepare = 6,
    this.maintenanceRooms = 2,
    this.totalRooms = 26,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double availablePercent = totalRooms > 0 ? (availableRooms / totalRooms) : 0.0;
    final double preparePercent = totalRooms > 0 ? (roomsToPrepare / totalRooms) : 0.0;
    final double maintenancePercent = totalRooms > 0 ? (maintenanceRooms / totalRooms) : 0.0;
    final int readyCount = availableRooms;
    final int houseKeepTotal = availableRooms + roomsToPrepare;
    final int houseKeepRatio = houseKeepTotal > 0 ? ((readyCount / houseKeepTotal) * 100).toInt() : 100;

    return SraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "État du parc hôtelier",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Mise à jour en temps réel",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.meeting_room_outlined, color: AppColors.gold, size: 22),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),

          // ── Progress Bars Sémantiques ──
          _buildProgressBarItem(
            label: "Chambres disponibles",
            valueText: "$availableRooms / $totalRooms",
            progress: availablePercent,
            color: AppColors.statusSuccess,
            isDark: isDark,
          ),
          const SizedBox(height: AppDimensions.spacingSm + 4),
          _buildProgressBarItem(
            label: "À préparer avant 14:00",
            valueText: "$roomsToPrepare chambres",
            progress: preparePercent,
            color: AppColors.statusWarning,
            isDark: isDark,
          ),
          const SizedBox(height: AppDimensions.spacingSm + 4),
          _buildProgressBarItem(
            label: "Indisponibles / Maintenance",
            valueText: "$maintenanceRooms / $totalRooms",
            progress: maintenancePercent,
            color: AppColors.statusError,
            isDark: isDark,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingSm + 4),
            child: Divider(height: 1, thickness: 1),
          ),

          // ── Résumé du Ménage ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nettoyage à clôturer",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.ink,
                      ),
                    ),
                    Text(
                      "$readyCount des $houseKeepTotal chambres prêtes.",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              SraStatusBadge.warning(
                label: "$houseKeepRatio%",
                small: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarItem({
    required String label,
    required String valueText,
    required double progress,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.ink,
              ),
            ),
            Text(
              valueText,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
