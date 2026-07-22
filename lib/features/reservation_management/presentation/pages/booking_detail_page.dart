import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/sra_input.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_state.dart';
import 'package:sra_hotel/features/reservation_management/presentation/widgets/payment_form_sheet.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class BookingDetailPage extends StatelessWidget {
  final Booking booking;

  const BookingDetailPage({
    super.key,
    required this.booking,
  });

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
        Booking currentBooking = booking;
        if (state is AdminBookingLoaded) {
          currentBooking = state.bookings.cast<Booking>().firstWhere((b) => b.id == booking.id, orElse: () => booking);
        }

        final checkinDate = DateTime.tryParse(currentBooking.checkIn) ?? DateTime.now();
        final checkoutDate = DateTime.tryParse(currentBooking.checkOut) ?? DateTime.now();
        final nights = checkoutDate.difference(checkinDate).inDays;
        final nightsCount = nights <= 0 ? 1 : nights;

        final isCancelled = currentBooking.statutBooking == 'ANNULE' || currentBooking.statutBooking == 'ANNULEE';
        final isConfirmed = currentBooking.statutBooking == 'CONFIRME' || currentBooking.statutBooking == 'CONFIRMEE';

        String statusText = currentBooking.statutBooking;
        if (isConfirmed) statusText = l10n.effectueStatus;
        if (isCancelled) statusText = l10n.cancelledStatus;
        if (currentBooking.statutBooking == 'EN_ATTENTE') statusText = l10n.pendingStatus;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.bookingDetailTitle,
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
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Header card with Reference & Status
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepBlue : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                boxShadow: const [AppShadows.shadowCard],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentBooking.reference,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.champagneGold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingSm,
                          vertical: 4.0,
                        ),
                        color: isConfirmed
                            ? AppColors.statusSuccess.withValues(alpha: 0.1)
                            : (isCancelled ? AppColors.statusError.withValues(alpha: 0.1) : AppColors.statusWarning.withValues(alpha: 0.1)),
                        child: Text(
                          statusText.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: isConfirmed
                                ? AppColors.statusSuccess
                                : (isCancelled ? AppColors.statusError : AppColors.statusWarning),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 0.5, color: Colors.black12),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.checkInLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(checkinDate),
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.checkOutLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMMMMd(Localizations.localeOf(context).toString()).format(checkoutDate),
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.stayDuration,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                      ),
                      Text(
                        l10n.nightsCount(nightsCount),
                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // Client & Details Header
            Text(
              l10n.clientInformationHeader,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.champagneGold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepBlue : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                boxShadow: const [AppShadows.shadowCard],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.occupantNameLabel, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(currentBooking.clientNom, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.adultsCountLabel, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text("${currentBooking.adultes}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                    ],
                  ),
                  if (currentBooking.enfants != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.childrenCountLabel, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        Text("${currentBooking.enfants}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),

            // Room details / Booking Lines list
            Text(
              l10n.reservedItemsHeader,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.champagneGold,
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

            // Financial Summary
            Text(
              l10n.financialSummary,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppColors.champagneGold,
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
