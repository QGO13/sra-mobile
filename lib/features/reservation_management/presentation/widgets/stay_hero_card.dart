import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Carte Hero d'en-tête du séjour — Reproduction Pixel-Perfect de `MyStayPage.tsx`.
class StayHeroCard extends StatefulWidget {
  final Booking booking;
  final BookingLine? selectedLine;
  final VoidCallback onEditStay;

  const StayHeroCard({
    super.key,
    required this.booking,
    this.selectedLine,
    required this.onEditStay,
  });

  @override
  State<StayHeroCard> createState() => _StayHeroCardState();
}

class _StayHeroCardState extends State<StayHeroCard> {
  bool _keyRequested = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final localeStr = Localizations.localeOf(context).toString();

    final line = widget.selectedLine;
    final checkinStr = line?.checkIn ?? widget.booking.checkIn;
    final checkoutStr = line?.checkOut ?? widget.booking.checkOut;
    final typeName = line?.roomTypeName ?? widget.booking.typeChambre;

    final checkinDate = DateTime.tryParse(checkinStr) ?? DateTime.now();
    final checkoutDate = DateTime.tryParse(checkoutStr) ?? DateTime.now().add(const Duration(days: 1));
    final nights = checkoutDate.difference(checkinDate).inDays;
    final nightsCount = nights <= 0 ? 1 : nights;

    final daysUntilCheckIn = checkinDate.difference(DateTime.now()).inDays;
    final isConfirmed = widget.booking.statutBooking == 'CONFIRME' || widget.booking.statutBooking == 'CONFIRMEE';

    String coverImage = 'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80';
    final lower = typeName.toLowerCase();
    if (lower.contains('suite')) {
      coverImage = 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80';
    } else if (lower.contains('prem') || lower.contains('sup')) {
      coverImage = 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800&q=80';
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 980),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Banner avec Chips Overlay ──
          Stack(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: coverImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? AppColors.darkSurface : AppColors.fog,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.champagneGold),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? AppColors.darkSurface : AppColors.fog,
                    child: const Icon(Icons.hotel, color: AppColors.champagneGold, size: 48),
                  ),
                ),
              ),

              // Chip Statut (Haut Gauche)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isConfirmed ? AppColors.champagneGold : AppColors.statusWarning,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: Text(
                    isConfirmed ? l10n.effectueStatus.toUpperCase() : widget.booking.statutBooking.toUpperCase(),
                    style: AppTextStyles.labelUppercase.copyWith(
                      color: AppColors.imperialNightBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                    ),
                  ),
                ),
              ),

              // Chip Décompte (Bas Droite)
              if (daysUntilCheckIn > 0)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.imperialNightBlue.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          l10n.inDaysCountdown(daysUntilCheckIn),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // ── Contenu du Séjour ──
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;
                    final infoWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line?.roomNumber != null && line!.roomNumber!.isNotEmpty
                              ? "$typeName · ${l10n.room} ${line.roomNumber} · ${widget.booking.reference}"
                              : "$typeName · ${widget.booking.reference}",
                          style: AppTextStyles.displayMedium.copyWith(
                            fontSize: 22,
                            height: 1.2,
                            color: isDark ? Colors.white : AppColors.imperialNightBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${DateFormat.MMMd(localeStr).format(checkinDate)} — ${DateFormat.yMMMMd(localeStr).format(checkoutDate)} · ${l10n.nightsCount(nightsCount)} · ${widget.booking.adultes} ${l10n.adultsCountLabel}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.inkMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );

                    final codeCardWidget = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.07) : const Color(0xFFF6F1E8),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        border: Border.all(
                          color: isDark ? Colors.white10 : AppColors.softGrey,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.yourBookingCode,
                            style: AppTextStyles.labelUppercase.copyWith(
                              fontSize: 9.5,
                              letterSpacing: 1.2,
                              color: AppColors.champagneGold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.booking.reference,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: isDark ? Colors.white : AppColors.imperialNightBlue,
                            ),
                          ),
                        ],
                      ),
                    );

                    return isWide
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: infoWidget),
                              const SizedBox(width: 16),
                              codeCardWidget,
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoWidget,
                              const SizedBox(height: 16),
                              codeCardWidget,
                            ],
                          );
                  },
                ),

                const SizedBox(height: AppDimensions.spacingLg),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: AppDimensions.spacingLg),

                // ── Boutons d'Action ──
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 240,
                      child: _keyRequested
                          ? OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.check_circle_rounded, color: AppColors.statusSuccess, size: 18),
                              label: Text(l10n.digitalKeyRequested),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.statusSuccess,
                                side: const BorderSide(color: AppColors.statusSuccess),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            )
                          : SraButton(
                              label: l10n.digitalKeyActivate,
                              icon: Icons.key_rounded,
                              onPressed: () {
                                setState(() => _keyRequested = true);
                              },
                            ),
                    ),
                    SizedBox(
                      width: 220,
                      child: OutlinedButton.icon(
                        onPressed: widget.onEditStay,
                        icon: const Icon(Icons.calendar_month_rounded, size: 18),
                        label: Text(l10n.modifyStay),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : AppColors.imperialNightBlue,
                          side: BorderSide(color: isDark ? Colors.white24 : AppColors.softGrey),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_keyRequested) ...[
                  const SizedBox(height: AppDimensions.spacingMd),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.spacingSm),
                    decoration: BoxDecoration(
                      color: AppColors.statusSuccess.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      border: Border.all(color: AppColors.statusSuccess, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.statusSuccess, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.digitalKeyAvailableNotice,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.statusSuccess,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
