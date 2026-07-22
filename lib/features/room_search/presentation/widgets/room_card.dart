import 'package:flutter/material.dart';
import 'package:sra_hotel/core/config/feature_flags.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/injection_container.dart' as di;
import 'package:sra_hotel/l10n/app_localizations.dart';

class RoomCard extends StatelessWidget {
  final RoomEntity room;
  final bool extraBedSelected;
  final ValueChanged<bool?> onExtraBedChanged;
  final VoidCallback onSelect;
  final bool isVerifying;

  const RoomCard({
    super.key,
    required this.room,
    required this.extraBedSelected,
    required this.onExtraBedChanged,
    required this.onSelect,
    this.isVerifying = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final String typeName = room.categoryName;
    final String img = _getImageUrl(room);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepBlue : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: isDark ? Colors.white10 : AppColors.softGrey,
            width: 1.0,
          ),
          boxShadow: const [AppShadows.shadowCard],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image block
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: img,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? Colors.grey[900] : Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.champagneGold),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? Colors.grey[900] : Colors.grey[200],
                  child: const Icon(Icons.hotel, color: AppColors.champagneGold, size: 40),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Label
                  Text(
                    l10n.accommodationLabel(typeName.toUpperCase()),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                      color: AppColors.champagneGold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Room Name / Number
                  Text(
                    l10n.roomNumberPrefix(room.numero),
                    style: AppTextStyles.displayMedium.copyWith(
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : AppColors.imperialNightBlue,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Room Description (simulated)
                  Text(
                    _getDescription(room.idTypeDeChambre),
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.6,
                      fontWeight: FontWeight.w300,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Features tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildTag(context, l10n.freeWifi),
                      _buildTag(context, l10n.airConditioned),
                      if (room.isSuite) _buildTag(context, l10n.privateLounge),
                    ],
                  ),
                  
                  // Conditional Extra Bed section (Suites only)
                  if (room.isSuite) ...[
                    const SizedBox(height: 8),
                    const Divider(height: 24, thickness: 0.5, color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.optionalExtraBed.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                color: AppColors.champagneGold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.extraBedPrice,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54, 
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: extraBedSelected,
                            activeColor: AppColors.champagneGold,
                            checkColor: Colors.black,
                            onChanged: isVerifying ? null : onExtraBedChanged,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  const Divider(height: 24, thickness: 0.5, color: Colors.black12),
                  
                  // Price & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.startingFrom,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white60 : Colors.black45,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              style: AppTextStyles.titleLarge.copyWith(
                                fontSize: 16.5,
                                color: AppColors.champagneGold,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(text: "${room.prixNuit.toStringAsFixed(0)} "),
                                TextSpan(
                                  text: l10n.nightsLabel,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 11,
                                    color: isDark ? Colors.white54 : Colors.black54,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Outlined or loading button
                      SizedBox(
                        height: 38,
                        child: isVerifying
                            ? const Center(
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: AppColors.champagneGold,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : SraButton(
                                onPressed: FeatureFlags.enableBooking ? onSelect : null,
                                label: FeatureFlags.enableBooking ? l10n.reserveButton : l10n.unavailableButton,
                                isOutlined: true,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.softGrey,
          width: 1.0,
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
          color: isDark ? Colors.white70 : AppColors.imperialNightBlue,
        ),
      ),
    );
  }

  String _getImageUrl(RoomEntity room) {
    if (room.imageUrl != null && room.imageUrl!.isNotEmpty) {
      if (room.imageUrl!.startsWith('/')) {
        final baseUrl = di.sl<ApiClient>().absoluteBaseUrl;
        return "$baseUrl${room.imageUrl}";
      }
      return room.imageUrl!;
    }

    final lower = room.idTypeDeChambre.toLowerCase();
    if (lower.contains('standard') || lower == '1' || lower == '21') {
      return "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80";
    }
    if (lower.contains('premium') || lower == '2' || lower == '23') {
      return "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80";
    }
    return "https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800&q=80";
  }

  String _getDescription(String typeId) {
    final lower = typeId.toLowerCase();
    if (lower.contains('standard') || lower == '1' || lower == '21') {
      return "Fonctionnelle et soignée, elle offre tout le nécessaire pour un séjour agréable : literie confortable, salle de bain moderne.";
    }
    if (lower.contains('premium') || lower == '2' || lower == '23') {
      return "Un niveau au-dessus. Spacieuse et lumineuse, elle offre une décoration plus raffinée et une literie de luxe.";
    }
    return "La Suite dispose d'un salon privé, d'une chambre spacieuse avec lit king-size et d'une salle de bain de luxe.";
  }
}

