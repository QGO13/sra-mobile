import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/edit_assignment_dialog.dart';

class AssignmentCalendarWidget extends StatefulWidget {
  final List<Room> rooms;
  final List<Booking> bookings;
  final Function(Booking) onBookingUpdated;

  const AssignmentCalendarWidget({
    super.key,
    required this.rooms,
    required this.bookings,
    required this.onBookingUpdated,
  });

  @override
  State<AssignmentCalendarWidget> createState() => _AssignmentCalendarWidgetState();
}

class _AssignmentCalendarWidgetState extends State<AssignmentCalendarWidget> {
  late DateTime _selectedMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  int _getDaysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  int _getStartWeekdayOfMonth(DateTime month) {
    // 1 = Monday, 7 = Sunday in Dart DateTime
    return DateTime(month.year, month.month, 1).weekday;
  }

  // Count active staying bookings on a specific date
  int _getOccupiedRoomsCount(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    return widget.bookings.where((b) {
      if (b.statutBooking == 'ANNULE' || b.statutBooking == 'ANNULEE') return false;

      final bIn = DateTime.tryParse(b.checkIn);
      final bOut = DateTime.tryParse(b.checkOut);
      if (bIn == null || bOut == null) return false;

      final cleanIn = DateTime(bIn.year, bIn.month, bIn.day);
      final cleanOut = DateTime(bOut.year, bOut.month, bOut.day);

      // Check if date falls in [checkIn, checkOut)
      return (cleanDate.isAtSameMomentAs(cleanIn) || cleanDate.isAfter(cleanIn)) && cleanDate.isBefore(cleanOut);
    }).length;
  }

  // Get arrivals (check-in) on a specific date
  List<Booking> _getArrivals(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    return widget.bookings.where((b) {
      if (b.statutBooking == 'ANNULE' || b.statutBooking == 'ANNULEE') return false;
      final bIn = DateTime.tryParse(b.checkIn);
      return bIn != null && DateTime(bIn.year, bIn.month, bIn.day).isAtSameMomentAs(cleanDate);
    }).toList();
  }

  // Get departures (check-out) on a specific date
  List<Booking> _getDepartures(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    return widget.bookings.where((b) {
      if (b.statutBooking == 'ANNULE' || b.statutBooking == 'ANNULEE') return false;
      final bOut = DateTime.tryParse(b.checkOut);
      return bOut != null && DateTime(bOut.year, bOut.month, bOut.day).isAtSameMomentAs(cleanDate);
    }).toList();
  }

  // Get current stayings (already checked in and staying) on a specific date
  List<Booking> _getStayings(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    return widget.bookings.where((b) {
      if (b.statutBooking == 'ANNULE' || b.statutBooking == 'ANNULEE') return false;
      final bIn = DateTime.tryParse(b.checkIn);
      final bOut = DateTime.tryParse(b.checkOut);
      if (bIn == null || bOut == null) return false;

      final cleanIn = DateTime(bIn.year, bIn.month, bIn.day);
      final cleanOut = DateTime(bOut.year, bOut.month, bOut.day);

      return cleanDate.isAfter(cleanIn) && cleanDate.isBefore(cleanOut);
    }).toList();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width >= 1024;

    final daysInMonth = _getDaysInMonth(_selectedMonth);
    final startWeekday = _getStartWeekdayOfMonth(_selectedMonth);
    // Grid items: empty spaces for start padding + days of month
    final gridItemCount = (startWeekday - 1) + daysInMonth;

    final today = DateTime.now();

    final selectedArrivals = _getArrivals(_selectedDay);
    final selectedDepartures = _getDepartures(_selectedDay);
    final selectedStayings = _getStayings(_selectedDay);

    Widget buildCalendarGrid() {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
          border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Month Selector Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.champagneGold),
                  onPressed: _prevMonth,
                ),
                Text(
                  DateFormat.yMMMM('fr').format(_selectedMonth).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.champagneGold),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Week Days Label
            Row(
              children: ['LU', 'MA', 'ME', 'JE', 'VE', 'SA', 'DI'].map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 16),

            // Days Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gridItemCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final dayOffset = index - (startWeekday - 1);
                if (dayOffset < 0) {
                  return const SizedBox(); // Empty padding cell
                }

                final dayNumber = dayOffset + 1;
                final cellDate = DateTime(_selectedMonth.year, _selectedMonth.month, dayNumber);
                final isSelected = DateUtils.isSameDay(cellDate, _selectedDay);
                final isCellToday = DateUtils.isSameDay(cellDate, today);

                final occupiedCount = _getOccupiedRoomsCount(cellDate);
                final double occupancyRate = widget.rooms.isNotEmpty 
                    ? (occupiedCount / widget.rooms.length) 
                    : 0.0;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDay = cellDate;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.champagneGold 
                            : (isCellToday ? AppColors.champagneGold.withValues(alpha: 0.5) : Colors.transparent),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      color: isSelected 
                          ? AppColors.champagneGold.withValues(alpha: 0.1)
                          : (occupancyRate > 0 
                              ? AppColors.champagneGold.withValues(alpha: occupancyRate * 0.25)
                              : null),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayNumber.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isCellToday || isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isCellToday ? AppColors.champagneGold : null,
                          ),
                        ),
                        if (occupiedCount > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            "$occupiedCount Ch.",
                            style: const TextStyle(fontSize: 8, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                          ),
                        ],
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

    Widget buildMovementsPanel() {
      Widget buildBookingTile(Booking booking, String type, Color color) {
        final roomNo = booking.lines.isNotEmpty ? booking.lines[0].roomNumber : null;
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
          ),
          color: isDark ? AppColors.deepBlue : Colors.white,
          child: ListTile(
            dense: true,
            title: Text(
              booking.clientNom,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              "${booking.reference} • ${booking.typeChambre}",
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (roomNo != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: AppColors.champagneGold.withValues(alpha: 0.1),
                    child: Text(
                      "Apart $roomNo",
                      style: const TextStyle(fontSize: 9, color: AppColors.champagneGold, fontWeight: FontWeight.bold),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: color.withValues(alpha: 0.1),
                  child: Text(
                    type,
                    style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditAssignmentDialog(
                  booking: booking,
                  rooms: widget.rooms,
                  bookings: widget.bookings,
                  onSave: widget.onBookingUpdated,
                ),
              );
            },
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mouvements du ${DateFormat.yMMMMEEEEd('fr').format(_selectedDay)} :",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.champagneGold),
            ),
            const SizedBox(height: 12),

            if (selectedArrivals.isEmpty && selectedDepartures.isEmpty && selectedStayings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    "Aucune activité pour ce jour.",
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
              )
            else ...[
              // Arrivals (Check-ins)
              if (selectedArrivals.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 4),
                  child: Text("ARRIVÉES (CHECK-IN)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
                ...selectedArrivals.map((b) => buildBookingTile(b, "CHECK-IN", AppColors.statusSuccess)),
              ],
              // Departures (Check-outs)
              if (selectedDepartures.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 8),
                  child: Text("DÉPARTS (CHECK-OUT)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
                ...selectedDepartures.map((b) => buildBookingTile(b, "CHECK-OUT", AppColors.statusError)),
              ],
              // Occupied / Stayings
              if (selectedStayings.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 8),
                  child: Text("EN SÉJOUR", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
                ...selectedStayings.map((b) => buildBookingTile(b, "SUR PLACE", AppColors.statusInfo)),
              ],
            ],
          ],
        ),
      );
    }

    if (isWide) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: buildCalendarGrid()),
            const SizedBox(width: AppDimensions.spacingLg),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(child: buildMovementsPanel()),
            ),
          ],
        ),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        children: [
          buildCalendarGrid(),
          const SizedBox(height: AppDimensions.spacingLg),
          buildMovementsPanel(),
        ],
      );
    }
  }
}
