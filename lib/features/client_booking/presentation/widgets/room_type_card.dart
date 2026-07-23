import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/injection_container.dart' as di;

class RoomTypeCard extends StatelessWidget {
  final BookingRoomType roomType;
  final VoidCallback onSelect;

  const RoomTypeCard({
    super.key,
    required this.roomType,
    required this.onSelect,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String imageUrl = roomType.images.isNotEmpty
        ? roomType.images[0]
        : "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80";

    if (imageUrl.startsWith('/')) {
      final baseUrl = di.sl<ApiClient>().absoluteBaseUrl;
      imageUrl = "$baseUrl$imageUrl";
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
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
          // Photo V2 fixed height to prevent text overflow on wide layout
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
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
            padding: const EdgeInsets.all(AppDimensions.spacingMd + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label uppercase
                Text(
                  "HÉBERGEMENT · ${roomType.nom.toUpperCase()}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelUppercase,
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                // Room type title
                Text(
                  roomType.nom,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.imperialNightBlue,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                // Description
                Text(
                  roomType.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                // Features
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildTag(context, "Capacité : ${roomType.capacite} pers."),
                    ...roomType.equipments.take(3).map((eq) => _buildTag(context, eq)),
                    if (roomType.equipments.length > 3)
                      _buildTag(context, "+${roomType.equipments.length - 3}"),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                const Divider(height: 1, thickness: 0.5, color: Colors.black12),
                const SizedBox(height: AppDimensions.spacingMd),
                // Price & Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "À partir de",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? Colors.white60 : Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${_formatCurrency(roomType.prixNuit)} / nuit",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.champagneGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: onSelect,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.champagneGold, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: Text(
                        "CHOISIR",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.champagneGold,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
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
        color: isDark ? AppColors.deepBlue : AppColors.ecruWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.softGrey,
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
}
