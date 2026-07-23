import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/injection_container.dart' as di;
import 'package:intl/intl.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onRemove;
  final ValueChanged<bool?> onSelectionChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final localeStr = Localizations.localeOf(context).toString();
    final room = item.room;
    final img = _getImageUrl(room);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepBlue : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: item.isSelected
                ? AppColors.champagneGold
                : (isDark ? Colors.white10 : AppColors.softGrey),
            width: item.isSelected ? 1.5 : 1.0,
          ),
          boxShadow: const [AppShadows.shadowCard],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row layout for image and title details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox sélection
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 38.0),
                  child: Checkbox(
                    value: item.isSelected,
                    activeColor: AppColors.champagneGold,
                    onChanged: onSelectionChanged,
                  ),
                ),

                // Room Photo (Left Thumbnail)
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  color: isDark ? Colors.grey[900] : Colors.grey[200],
                  child: CachedNetworkImage(
                    imageUrl: img,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.champagneGold),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.hotel,
                      color: AppColors.champagneGold,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Right Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14.0, right: 12.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row: Category & Delete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              room.categoryName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: AppColors.champagneGold,
                              ),
                            ),
                            GestureDetector(
                              onTap: onRemove,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Room Name (Category)
                        Text(
                          room.categoryName,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: isDark ? Colors.white : AppColors.imperialNightBlue,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Base Price
                        Text(
                          l10n.priceFormat(room.prixNuit.toStringAsFixed(0)),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w300,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Stay Dates & Nights count
                        Text(
                          "${DateFormat.MMMd(localeStr).format(item.checkIn)} → ${DateFormat.MMMd(localeStr).format(item.checkOut)} (${l10n.nightsCount(item.nightsCount)})",
                          style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.champagneGold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Badge Petit-déjeuner offert
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.statusSuccess.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.free_breakfast_outlined, size: 12, color: AppColors.statusSuccess),
                              const SizedBox(width: 4),
                              Text(
                                l10n.freeBreakfastIncluded,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.statusSuccess,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 16, thickness: 0.5, color: Colors.black12),
                  // Subtotal row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.subtotalRoom,
                        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12.5, color: Colors.grey),
                      ),
                      Text(
                        "${item.itemTotal.toStringAsFixed(0)} FCFA",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.champagneGold,
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
}

