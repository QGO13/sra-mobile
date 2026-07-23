import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/booking_detail_page.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de niveau 2 : Liste des éléments / chambres d'une réservation multi-chambres.
class BookingItemsPage extends StatelessWidget {
  final Booking booking;

  const BookingItemsPage({
    super.key,
    required this.booking,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  String _getRoomImageUrl(String typeName) {
    final lower = typeName.toLowerCase();
    if (lower.contains('suite')) {
      return 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80';
    } else if (lower.contains('prem') || lower.contains('sup')) {
      return 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800&q=80';
    } else {
      return 'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final adminBookingBloc = context.read<AdminBookingBloc>();

    final lines = booking.lines.isNotEmpty
        ? booking.lines
        : [
            BookingLine(
              id: booking.id,
              roomTypeName: booking.typeChambre,
              price: booking.prixTotal,
              checkIn: booking.checkIn,
              checkOut: booking.checkOut,
              occupantName: booking.clientNom,
            )
          ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          booking.reference,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.imperialNightBlue,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec résumé de réservation
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.deepBlue : Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                      boxShadow: const [AppShadows.shadowCard],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.clientNom,
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${lines.length} hébergement${lines.length > 1 ? 's' : ''} au total",
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          _formatCurrency(booking.prixTotal),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.champagneGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),

                  Text(
                    l10n.bookingDetailsTitle,
                    style: AppTextStyles.labelUppercase.copyWith(
                      color: AppColors.champagneGold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  // Liste des éléments (chambres)
                  ResponsiveListGridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: lines.length,
                    maxCrossAxisExtent: 440,
                    mainAxisExtent: 140,
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      final checkin = DateTime.tryParse(line.checkIn) ?? DateTime.tryParse(booking.checkIn) ?? DateTime.now();
                      final checkout = DateTime.tryParse(line.checkOut) ?? DateTime.tryParse(booking.checkOut) ?? DateTime.now();
                      final rangeStr = "${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(checkin)} → ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(checkout)}";

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.deepBlue : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                          boxShadow: const [AppShadows.shadowCard],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: adminBookingBloc,
                                  child: BookingDetailPage(
                                    booking: booking,
                                    selectedLine: line,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                  child: CachedNetworkImage(
                                    imageUrl: _getRoomImageUrl(line.roomTypeName),
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 90,
                                      height: 90,
                                      color: isDark ? AppColors.darkSurface : AppColors.fog,
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.champagneGold),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 90,
                                      height: 90,
                                      color: isDark ? AppColors.darkSurface : AppColors.fog,
                                      child: const Icon(Icons.hotel, color: AppColors.champagneGold, size: 28),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        line.roomNumber != null && line.roomNumber!.isNotEmpty
                                            ? "${line.roomTypeName} · ${l10n.room} ${line.roomNumber}"
                                            : line.roomTypeName,
                                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      if (line.occupantName != null && line.occupantName!.isNotEmpty) ...[
                                        Text(
                                          line.occupantName!,
                                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                        ),
                                        const SizedBox(height: 2),
                                      ],
                                      Text(
                                        rangeStr,
                                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatCurrency(line.price),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.champagneGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.champagneGold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
