import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/cards/sra_card.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';

/// Item de la file d'attente d'action d'administration
class AdminActionItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String statusLabel;
  final SraStatusType statusType;
  final VoidCallback? onTap;

  const AdminActionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.statusLabel,
    required this.statusType,
    this.onTap,
  });
}

/// Widget AdminActionQueue — Équivalent du composant React `AdminActionQueue.tsx` de SRAh V2.
///
/// Affiche la liste des tâches et alertes administratives à traiter en priorité.
class AdminActionQueue extends StatelessWidget {
  final List<AdminActionItem>? items;

  const AdminActionQueue({
    super.key,
    this.items,
  });

  List<AdminActionItem> _getDefaultItems(BuildContext context) {
    return [
      AdminActionItem(
        id: '1',
        title: 'Réservation #RES-8902',
        description: 'Chambre Deluxe • Arrivée prévue aujourd\'hui à 14h00',
        icon: Icons.bookmark_added_outlined,
        statusLabel: 'Attente attribution',
        statusType: SraStatusType.warning,
      ),
      AdminActionItem(
        id: '2',
        title: 'Facture #INV-2026-042',
        description: 'Règlement Mobile Money à valider (75 000 FCFA)',
        icon: Icons.receipt_long_outlined,
        statusLabel: 'À vérifier',
        statusType: SraStatusType.info,
      ),
      AdminActionItem(
        id: '3',
        title: 'Chambre #105',
        description: 'Signalement dysfonctionnement climatisation par la gouvernante',
        icon: Icons.build_circle_outlined,
        statusLabel: 'Maintenance requise',
        statusType: SraStatusType.error,
      ),
      AdminActionItem(
        id: '4',
        title: 'Inspection Étage 2',
        description: '4 chambres nettoyées en attente de confirmation finale',
        icon: Icons.cleaning_services_outlined,
        statusLabel: 'Prêt à valider',
        statusType: SraStatusType.success,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionItems = items ?? _getDefaultItems(context);

    return SraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: AppDimensions.avatarSize,
                    height: AppDimensions.avatarSize,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      size: AppDimensions.iconSizeMd,
                      color: AppColors.gold,
                    ),
                  ),
                  AppDimensions.hGapSm,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIONS À TRAITER',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Alertes et priorités du jour',
                        style: AppTextStyles.labelMuted.copyWith(
                          color: isDark ? AppColors.inkMuted : AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSm,
                  vertical: AppDimensions.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.statusWarning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '${actionItems.length} urgences',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.statusWarning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          AppDimensions.vGapMd,
          const Divider(height: 1, color: AppColors.mist),
          AppDimensions.vGapSm,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actionItems.length,
            separatorBuilder: (context, index) => const Divider(
              height: AppDimensions.spacingSm * 2,
              color: AppColors.mist,
            ),
            itemBuilder: (context, index) {
              final item = actionItems[index];
              return InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingXs,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: AppDimensions.iconSizeLg,
                        color: isDark ? AppColors.goldLight2 : AppColors.gold,
                      ),
                      AppDimensions.hGapSm,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.white : AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppDimensions.vGapXs,
                            Text(
                              item.description,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.overlayDarkMedium
                                    : AppColors.inkMuted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      AppDimensions.hGapSm,
                      SraStatusBadge(
                        label: item.statusLabel,
                        type: item.statusType,
                        small: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
