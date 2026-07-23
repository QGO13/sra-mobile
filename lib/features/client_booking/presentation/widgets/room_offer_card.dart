import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Data model d'une offre de chambre pour la réservation client
class StayRoomOfferData {
  final String id;
  final String name;
  final int price;
  final int capacity;
  final int surface;
  final String view;
  final String description;
  final String image;
  final int available;
  final String? highlight;

  const StayRoomOfferData({
    required this.id,
    required this.name,
    required this.price,
    required this.capacity,
    required this.surface,
    required this.view,
    required this.description,
    required this.image,
    required this.available,
    this.highlight,
  });
}

/// Carte d'offre de chambre — Reproduction Pixel-Perfect de `RoomOfferCard.tsx`.
class RoomOfferCardWidget extends StatelessWidget {
  final StayRoomOfferData offer;
  final bool selected;
  final bool disabled;
  final ValueChanged<StayRoomOfferData> onSelect;

  const RoomOfferCardWidget({
    super.key,
    required this.offer,
    required this.selected,
    required this.disabled,
    required this.onSelect,
  });

  String _formatFcfa(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final cardBorder = selected
        ? AppColors.gold
        : (isDark ? AppColors.darkBorder : AppColors.mist);

    final availStr = offer.available > 1
        ? l10n.availablePlural(offer.available)
        : l10n.availableSingular(offer.available);

    return Opacity(
      opacity: disabled ? 0.58 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: cardBorder,
            width: selected ? AppDimensions.borderMedium : AppDimensions.borderThin,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Visuel de la chambre (180px) ──
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: AppColors.darkSurface,
                  child: Image.network(
                    offer.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkElevated,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.king_bed_outlined,
                          color: AppColors.gold,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),

                // Badge Coup de Cœur / Highlight
                if (offer.highlight != null)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      child: Text(
                        offer.highlight!,
                        style: AppTextStyles.labelUppercase.copyWith(
                          fontSize: 10,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),

                // Badge Disponibilité / Capacité
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: disabled
                          ? AppColors.darkSurface.withValues(alpha: 0.85)
                          : AppColors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: Text(
                      disabled ? l10n.insufficientCapacity : availStr,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: disabled ? AppColors.white : AppColors.statusSuccess,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Description & Détails ──
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          offer.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      if (selected)
                        StatusBadge(
                          label: l10n.selectedBadge,
                          color: AppColors.gold,
                        ),
                    ],
                  ),
                  AppDimensions.vGapXs,

                  Text(
                    l10n.startingFromPerNight(_formatFcfa(offer.price)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textMuted,
                    ),
                  ),
                  AppDimensions.vGapSm,

                  Text(
                    offer.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textMuted,
                      height: 1.3,
                    ),
                  ),
                  AppDimensions.vGapMd,

                  // Attributes row: Capacité | Surface | Vue
                  Row(
                    children: [
                      _AttrTag(
                        icon: Icons.people_alt_outlined,
                        label: '${offer.capacity} pers.',
                      ),
                      AppDimensions.hGapMd,
                      _AttrTag(
                        icon: Icons.square_foot_outlined,
                        label: '${offer.surface} m²',
                      ),
                      AppDimensions.hGapMd,
                      Expanded(
                        child: _AttrTag(
                          icon: Icons.remove_red_eye_outlined,
                          label: offer.view,
                        ),
                      ),
                    ],
                  ),
                  AppDimensions.vGapLg,

                  // Bouton d'action
                  SizedBox(
                    width: double.infinity,
                    child: selected
                        ? OutlinedButton(
                            onPressed: disabled ? null : () => onSelect(offer),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.gold,
                              side: const BorderSide(color: AppColors.gold),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.spacingSm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                              ),
                            ),
                            child: Text(l10n.selectedRoomButton),
                          )
                        : SraButton(
                            label: l10n.chooseRoomButton,
                            onPressed: disabled ? null : () => onSelect(offer),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttrTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AttrTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        AppDimensions.hGapXs,
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11.5,
            color: color,
          ),
        ),
      ],
    );
  }
}
