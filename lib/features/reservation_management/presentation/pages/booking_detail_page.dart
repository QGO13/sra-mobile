import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_state.dart';
import 'package:sra_hotel/features/reservation_management/presentation/widgets/arrival_preferences_card.dart';
import 'package:sra_hotel/features/reservation_management/presentation/widgets/edit_stay_dialog.dart';
import 'package:sra_hotel/features/reservation_management/presentation/widgets/payment_form_sheet.dart';
import 'package:sra_hotel/features/reservation_management/presentation/widgets/stay_hero_card.dart';
import 'package:sra_hotel/features/reservation_management/presentation/widgets/stay_landmarks_card.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page Détail de Réservation / Mon Séjour — Reproduction Pixel-Perfect de `MyStayPage.tsx`.
class BookingDetailPage extends StatefulWidget {
  final Booking booking;
  final BookingLine? selectedLine;

  const BookingDetailPage({
    super.key,
    required this.booking,
    this.selectedLine,
  });

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  bool _modificationSent = false;

  void _showEditStayDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (ctx) => EditStayDialog(
        currentCheckIn: booking.checkIn,
        currentCheckOut: booking.checkOut,
        onSendRequest: (msg) {
          setState(() => _modificationSent = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.modificationRequestSent),
              backgroundColor: AppColors.statusSuccess,
            ),
          );
        },
      ),
    );
  }

  void _showEditPriceDialog(BuildContext context, String bookingId, String lineId, double currentPrice) {
    final controller = TextEditingController(text: currentPrice.toStringAsFixed(0));
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(l10n.editPrice),
          content: SraInput(
            controller: controller,
            label: l10n.priceLabel,
            placeholder: "0",
            keyboardType: TextInputType.number,
            suffixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text('FCFA', style: TextStyle(color: Colors.grey)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelLabel, style: const TextStyle(color: AppColors.champagneGold)),
            ),
            SraButton(
              onPressed: () {
                final price = double.tryParse(controller.text);
                if (price != null && price > 0) {
                  context.read<AdminBookingBloc>().add(
                    UpdateBookingLineEvent(bookingId: bookingId, lineId: lineId, price: price),
                  );
                  Navigator.pop(ctx);
                }
              },
              label: l10n.validateLabel,
            ),
          ],
        );
      },
    );
  }

  void _showDiscountDialog(BuildContext context, String bookingId, double currentDiscount) {
    final controller = TextEditingController(text: currentDiscount.toStringAsFixed(0));
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(l10n.adjustDiscount),
          content: SraInput(
            controller: controller,
            label: l10n.discountPercentageLabel,
            placeholder: "0",
            keyboardType: TextInputType.number,
            suffixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text('%', style: TextStyle(color: Colors.grey)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelLabel, style: const TextStyle(color: AppColors.champagneGold)),
            ),
            SraButton(
              onPressed: () {
                final discount = double.tryParse(controller.text);
                if (discount != null && discount >= 0 && discount <= 100) {
                  context.read<AdminBookingBloc>().add(
                    ApplyGlobalDiscountEvent(bookingId: bookingId, discountPercentage: discount),
                  );
                  Navigator.pop(ctx);
                }
              },
              label: l10n.validateLabel,
            ),
          ],
        );
      },
    );
  }

  void _showPaymentSheet(BuildContext context, Booking booking) {
    final bookingBloc = context.read<AdminBookingBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.deepBlue
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return PaymentFormSheet(
          initialAmount: booking.prixTotal,
          onSettle: (amount, method) {
            bookingBloc.add(
              PayBookingEvent(bookingId: booking.id, amount: amount, paymentMethod: method),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.paymentSuccess),
                backgroundColor: AppColors.statusSuccess,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AdminBookingBloc, AdminBookingState>(
      builder: (context, state) {
        Booking currentBooking = widget.booking;
        if (state is AdminBookingLoaded) {
          currentBooking = state.bookings.cast<Booking>().firstWhere(
            (b) => b.id == widget.booking.id,
            orElse: () => widget.booking,
          );
        }

        final checkinDate = DateTime.tryParse(currentBooking.checkIn) ?? DateTime.now();
        final checkoutDate = DateTime.tryParse(currentBooking.checkOut) ?? DateTime.now();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              l10n.myStayTitle,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.imperialNightBlue,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: isDark ? Colors.white : AppColors.imperialNightBlue,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingLg,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── En-tête de Titre "Votre prochain moment" ──
                    Text(
                      l10n.nextMomentHeader,
                      style: AppTextStyles.labelUppercase.copyWith(
                        color: AppColors.champagneGold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      l10n.myStayTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayMedium.copyWith(
                        fontSize: 34,
                        color: isDark ? Colors.white : AppColors.imperialNightBlue,
                      ),
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      l10n.myStaySubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Carte Hero principale ──
                    StayHeroCard(
                      booking: currentBooking,
                      selectedLine: widget.selectedLine,
                      onEditStay: () => _showEditStayDialog(context, currentBooking),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    if (_modificationSent) ...[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: AppDimensions.spacingLg),
                        padding: const EdgeInsets.all(AppDimensions.spacingMd),
                        decoration: BoxDecoration(
                          color: AppColors.statusSuccess.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                          border: Border.all(color: AppColors.statusSuccess, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, color: AppColors.statusSuccess),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.modificationRequestSent,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.statusSuccess,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Grille 2 colonnes (Préférences d'arrivée + Repères) ──
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 768;
                        return isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(flex: 6, child: ArrivalPreferencesCard()),
                                  const SizedBox(width: AppDimensions.spacingLg),
                                  const Expanded(flex: 5, child: StayLandmarksCard()),
                                ],
                              )
                            : const Column(
                                children: [
                                  ArrivalPreferencesCard(),
                                  SizedBox(height: AppDimensions.spacingLg),
                                  StayLandmarksCard(),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Détails des Chambres Réservées ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.reservedItemsHeader,
                        style: AppTextStyles.labelUppercase.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: AppColors.champagneGold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),

                    if (currentBooking.lines.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.spacingMd),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.deepBlue : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                          border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                          boxShadow: const [AppShadows.shadowCard],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentBooking.typeChambre,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            Text(
                              "${currentBooking.prixTotal.toStringAsFixed(0)} FCFA",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.champagneGold),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentBooking.lines.length,
                        itemBuilder: (context, index) {
                          final line = currentBooking.lines[index];
                          final lineCheckin = DateTime.tryParse(line.checkIn) ?? checkinDate;
                          final lineCheckout = DateTime.tryParse(line.checkOut) ?? checkoutDate;
                          final lineNights = lineCheckout.difference(lineCheckin).inDays;
                          final lineNightsCount = lineNights <= 0 ? 1 : lineNights;

                          return Container(
                            margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        line.roomTypeName,
                                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${l10n.stayLabel} ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(lineCheckin)} → ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(lineCheckout)} ($lineNightsCount ${l10n.nightsLabel})",
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      if (line.occupantName != null && line.occupantName!.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          "${l10n.occupantLabel} ${line.occupantName}",
                                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                      if (line.roomNumber != null && line.roomNumber!.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          "${l10n.roomLabel} N° ${line.roomNumber}",
                                          style: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 11),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${line.price.toStringAsFixed(0)} FCFA",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.champagneGold),
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        _showEditPriceDialog(context, currentBooking.id, line.id, line.price);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Récapitulatif Financier ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.financialSummary,
                        style: AppTextStyles.labelUppercase.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: AppColors.champagneGold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingSm),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.deepBlue : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                        boxShadow: const [AppShadows.shadowCard],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.subtotal, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(
                                "${currentBooking.lines.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(0)} FCFA",
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (currentBooking.discountPercentage > 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${l10n.globalDiscount} (${currentBooking.discountPercentage.toStringAsFixed(0)}%) :", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                Text(
                                  "-${(currentBooking.lines.fold(0.0, (sum, item) => sum + item.price) * currentBooking.discountPercentage / 100).toStringAsFixed(0)} FCFA",
                                  style: const TextStyle(color: AppColors.statusError, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.taxesAndServices, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(l10n.included, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.green.shade600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              icon: const Icon(Icons.percent, size: 14, color: AppColors.champagneGold),
                              label: Text(l10n.adjustDiscount, style: const TextStyle(color: AppColors.champagneGold, fontSize: 12, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                _showDiscountDialog(context, currentBooking.id, currentBooking.discountPercentage);
                              },
                            ),
                          ),
                          const Divider(height: 1, thickness: 0.5, color: Colors.black12),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.totalPrice,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.imperialNightBlue,
                                ),
                              ),
                              Text(
                                "${currentBooking.prixTotal.toStringAsFixed(0)} FCFA",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Montant Payé :", style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(
                                "${currentBooking.totalPaid.toStringAsFixed(0)} FCFA",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.statusSuccess),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Solde Restant (Balance Due) :", style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(
                                "${currentBooking.balanceDue.toStringAsFixed(0)} FCFA",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: currentBooking.balanceDue > 0 ? AppColors.statusWarning : AppColors.statusSuccess,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: currentBooking.hasMinDepositPaid
                                  ? AppColors.statusSuccess.withValues(alpha: 0.12)
                                  : AppColors.statusWarning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                              border: Border.all(
                                color: currentBooking.hasMinDepositPaid ? AppColors.statusSuccess : AppColors.statusWarning,
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  currentBooking.hasMinDepositPaid ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                  size: 14,
                                  color: currentBooking.hasMinDepositPaid ? AppColors.statusSuccess : AppColors.statusWarning,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    currentBooking.hasMinDepositPaid
                                        ? "Acompte 50% validé · Check-in autorisé"
                                        : "Acompte 50% requis pour le Check-in (Solde acompte: ${((currentBooking.prixTotal * 0.5) - currentBooking.totalPaid).clamp(0, double.infinity).toStringAsFixed(0)} FCFA)",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: currentBooking.hasMinDepositPaid ? AppColors.statusSuccess : AppColors.statusWarning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (currentBooking.statutBooking != 'CONFIRMEE' && currentBooking.statutBooking != 'ANNULEE' && currentBooking.statutBooking != 'TERMINEE') ...[
                      const SizedBox(height: AppDimensions.spacingLg),
                      SizedBox(
                        width: double.infinity,
                        child: SraButton(
                          icon: Icons.payment,
                          label: l10n.payBooking,
                          onPressed: () {
                            _showPaymentSheet(context, currentBooking);
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
