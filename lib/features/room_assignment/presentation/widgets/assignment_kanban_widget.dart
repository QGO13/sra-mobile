import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/edit_assignment_dialog.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AssignmentKanbanWidget extends StatelessWidget {
  final List<Room> rooms;
  final List<Booking> bookings;
  final Function(Booking) onBookingUpdated;

  const AssignmentKanbanWidget({
    super.key,
    required this.rooms,
    required this.bookings,
    required this.onBookingUpdated,
  });

  List<Booking> _getBookingsByStatus(String status) {
    return bookings.where((b) {
      final s = b.statutBooking.toUpperCase();
      if (status == 'CONFIRME') {
        return s == 'CONFIRME' || s == 'CONFIRMEE';
      }
      if (status == 'ANNULE') {
        return s == 'ANNULE' || s == 'ANNULEE';
      }
      return s == status;
    }).toList();
  }

  Color _getColumnColor(String status) {
    switch (status) {
      case 'EN_ATTENTE':
        return Colors.orange.shade700;
      case 'CONFIRME':
        return AppColors.champagneGold;
      case 'EFFECTUE':
        return AppColors.statusInfo;
      case 'TERMINEE':
        return AppColors.statusSuccess;
      case 'ANNULE':
        return AppColors.statusError;
      default:
        return AppColors.textMuted;
    }
  }

  String _getColumnTitle(String status, AppLocalizations l10n) {
    switch (status) {
      case 'EN_ATTENTE':
        return l10n.pendingStatus;
      case 'CONFIRME':
        return l10n.filterConfirmed;
      case 'EFFECTUE':
        return "En séjour";
      case 'TERMINEE':
        return "Terminé";
      case 'ANNULE':
        return l10n.filterCancelled;
      default:
        return "Inconnu";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= 1024;

    final columns = ['EN_ATTENTE', 'CONFIRME', 'EFFECTUE', 'TERMINEE', 'ANNULE'];

    Widget buildKanbanColumns() {
      final list = columns.map((colStatus) {
        final colBookings = _getBookingsByStatus(colStatus);
        final colColor = _getColumnColor(colStatus);

        return Container(
          width: isWide ? null : 290.0,
          margin: const EdgeInsets.only(right: AppDimensions.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
            border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Column Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                    left: BorderSide(color: colColor, width: 3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getColumnTitle(colStatus, l10n).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: colColor.withValues(alpha: 0.15),
                      child: Text(
                        colBookings.length.toString(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colColor),
                      ),
                    ),
                  ],
                ),
              ),
              // Column Cards List
              Expanded(
                child: ListView.builder(
                  itemCount: colBookings.length,
                  padding: const EdgeInsets.all(AppDimensions.spacingSm),
                  itemBuilder: (context, index) {
                    final booking = colBookings[index];
                    final roomNo = booking.lines.isNotEmpty ? booking.lines[0].roomNumber : null;
                    final checkIn = DateTime.tryParse(booking.checkIn) ?? DateTime.now();
                    final checkOut = DateTime.tryParse(booking.checkOut) ?? DateTime.now();
                    final dateRange = "${DateFormat.MMMd('fr').format(checkIn)} - ${DateFormat.MMMd('fr').format(checkOut)}";

                    return Card(
                      margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                      ),
                      color: isDark ? AppColors.imperialNightBlue : Colors.white,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditAssignmentDialog(
                              booking: booking,
                              rooms: rooms,
                              bookings: bookings,
                              onSave: onBookingUpdated,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    booking.reference,
                                    style: AppTextStyles.monospace.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: AppColors.champagneGold,
                                    ),
                                  ),
                                  if (roomNo != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      color: AppColors.champagneGold.withValues(alpha: 0.1),
                                      child: Text(
                                        "Ch. $roomNo",
                                        style: const TextStyle(fontSize: 9, color: AppColors.champagneGold, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                booking.clientNom,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${booking.typeChambre} • $dateRange",
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${booking.adultes} Ad. / ${(booking.enfants ?? 0)} Enf.",
                                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                  // Quick status shift popup
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_forward, size: 16, color: AppColors.champagneGold),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 120),
                                    onSelected: (newStatus) {
                                      final updated = Booking(
                                        id: booking.id,
                                        reference: booking.reference,
                                        clientNom: booking.clientNom,
                                        typeChambre: booking.typeChambre,
                                        checkIn: booking.checkIn,
                                        checkOut: booking.checkOut,
                                        adultes: booking.adultes,
                                        enfants: booking.enfants,
                                        statutBooking: newStatus,
                                        prixTotal: booking.prixTotal,
                                        lines: booking.lines,
                                      );
                                      onBookingUpdated(updated);
                                    },
                                    itemBuilder: (context) {
                                      return columns
                                          .where((s) => s != colStatus)
                                          .map((s) => PopupMenuItem<String>(
                                                value: s,
                                                child: Text(
                                                  "Déplacer vers ${_getColumnTitle(s, l10n)}",
                                                  style: const TextStyle(fontSize: 11),
                                                ),
                                              ))
                                          .toList();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList();

      if (isWide) {
        return Row(
          children: list.map((col) => Expanded(child: col)).toList(),
        );
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: list),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: buildKanbanColumns(),
    );
  }
}
