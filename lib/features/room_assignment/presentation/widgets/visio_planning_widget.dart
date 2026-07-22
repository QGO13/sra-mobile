import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/edit_assignment_dialog.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class VisioPlanningWidget extends StatefulWidget {
  final List<Room> rooms;
  final List<Booking> bookings;
  final Function(Booking) onBookingUpdated;

  const VisioPlanningWidget({
    super.key,
    required this.rooms,
    required this.bookings,
    required this.onBookingUpdated,
  });

  @override
  State<VisioPlanningWidget> createState() => _VisioPlanningWidgetState();
}

class _VisioPlanningWidgetState extends State<VisioPlanningWidget> {
  late ScrollController _leftScrollController;
  late ScrollController _rightScrollController;
  late ScrollController _horizontalScrollController;
  late DateTime _startDate;
  final int _totalDays = 30; // 30 days view
  final double _dayColumnWidth = 80.0;
  final double _rowHeight = 65.0;

  @override
  void initState() {
    super.initState();
    _leftScrollController = ScrollController();
    _rightScrollController = ScrollController();
    _horizontalScrollController = ScrollController();

    // Link vertical scrolls together
    _leftScrollController.addListener(_syncScrolls);
    _rightScrollController.addListener(_syncScrolls);

    // Timeline starts 3 days before today to show past context
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 3));

    // Auto-scroll to today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday(animate: false);
    });
  }

  void _syncScrolls() {
    if (_leftScrollController.hasClients && _rightScrollController.hasClients) {
      if (_leftScrollController.offset != _rightScrollController.offset) {
        _leftScrollController.jumpTo(_rightScrollController.offset);
      }
    }
  }

  void _scrollToToday({bool animate = true}) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final diff = todayMidnight.difference(DateTime(_startDate.year, _startDate.month, _startDate.day)).inDays;
    if (diff >= 0 && diff < _totalDays) {
      final targetOffset = diff * _dayColumnWidth;
      if (_horizontalScrollController.hasClients) {
        if (animate) {
          _horizontalScrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        } else {
          _horizontalScrollController.jumpTo(targetOffset);
        }
      }
    }
  }

  void _goToPreviousPeriod() {
    setState(() {
      _startDate = _startDate.subtract(const Duration(days: 30));
    });
  }

  void _goToNextPeriod() {
    setState(() {
      _startDate = _startDate.add(const Duration(days: 30));
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 3));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday(animate: true);
    });
  }

  @override
  void dispose() {
    _leftScrollController.removeListener(_syncScrolls);
    _rightScrollController.removeListener(_syncScrolls);
    _leftScrollController.dispose();
    _rightScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  List<DateTime> _getTimelineDates() {
    return List.generate(_totalDays, (index) => _startDate.add(Duration(days: index)));
  }

  List<Booking> _getBookingsForRoom(String roomNo) {
    final endDate = _startDate.add(Duration(days: _totalDays));
    return widget.bookings.where((booking) {
      if (booking.statutBooking == 'ANNULE' || booking.statutBooking == 'ANNULEE') return false;

      final assignedRoom = booking.lines.isNotEmpty ? booking.lines[0].roomNumber : null;
      if (assignedRoom != roomNo) return false;

      final checkIn = DateTime.tryParse(booking.checkIn);
      final checkOut = DateTime.tryParse(booking.checkOut);
      if (checkIn == null || checkOut == null) return false;

      return checkIn.isBefore(endDate) && checkOut.isAfter(_startDate);
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRME':
      case 'CONFIRMEE':
        return AppColors.champagneGold;
      case 'TERMINEE':
        return AppColors.statusSuccess;
      case 'EN_ATTENTE':
        return const Color(0xFF34495E);
      default:
        return AppColors.textMuted;
    }
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).languageCode;
    final firstMonth = DateFormat.yMMMM(locale).format(_startDate);
    final lastMonth = DateFormat.yMMMM(locale).format(_startDate.add(Duration(days: _totalDays - 1)));
    final rangeText = firstMonth == lastMonth ? firstMonth : "$firstMonth - $lastMonth";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rangeText.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.champagneGold, letterSpacing: 0.5),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.champagneGold),
                onPressed: _goToPreviousPeriod,
              ),
              OutlinedButton(
                onPressed: _goToToday,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.champagneGold,
                  side: const BorderSide(color: AppColors.champagneGold, width: 1),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(l10n.todayLabel.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.champagneGold),
                onPressed: _goToNextPeriod,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dates = _getTimelineDates();
    final totalWidth = _dayColumnWidth * _totalDays;

    return Column(
      children: [
        _buildHeader(context, l10n),
        Expanded(
          child: Row(
            children: [
              // 1. Sticky Left Column: Rooms List
              Container(
                width: 110,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
                  border: Border(
                    right: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                        ),
                      ),
                      child: Text(
                        l10n.roomsTab.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.champagneGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _leftScrollController,
                        physics: const ClampingScrollPhysics(),
                        itemCount: widget.rooms.length,
                        itemBuilder: (context, index) {
                          final room = widget.rooms[index];
                          return Container(
                            height: _rowHeight,
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Apart ${room.numero}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  room.type.split(' ').last,
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Horizontally scrollable timeline grid
              Expanded(
                child: Theme(
                  data: theme.copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(AppColors.champagneGold.withValues(alpha: 0.6)),
                      trackColor: WidgetStateProperty.all(isDark ? Colors.white10 : AppColors.softGrey.withValues(alpha: 0.3)),
                      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
                      thickness: WidgetStateProperty.all(8.0),
                      radius: const Radius.circular(4),
                    ),
                  ),
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalWidth,
                        child: Column(
                          children: [
                            // Dates Header Row
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.deepBlue : Colors.white,
                                border: Border(
                                  bottom: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                                ),
                              ),
                              child: Row(
                                children: dates.map((date) {
                                  final isToday = DateUtils.isSameDay(date, DateTime.now());
                                  return Container(
                                    width: _dayColumnWidth,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: isDark ? Colors.white10 : AppColors.softGrey.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      color: isToday ? AppColors.champagneGold.withValues(alpha: 0.1) : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat.E(locale).format(date).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                            color: isToday ? AppColors.champagneGold : AppColors.textMuted,
                                          ),
                                        ),
                                        Text(
                                          DateFormat.d(locale).format(date),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isToday ? AppColors.champagneGold : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            // Room Rows Timeline
                            Expanded(
                              child: ListView.builder(
                                controller: _rightScrollController,
                                physics: const ClampingScrollPhysics(),
                                itemCount: widget.rooms.length,
                                itemBuilder: (context, rowIndex) {
                                  final room = widget.rooms[rowIndex];
                                  final roomBookings = _getBookingsForRoom(room.numero);

                                  return SizedBox(
                                    height: _rowHeight,
                                    child: Stack(
                                      children: [
                                        // Grid backgrounds columns
                                        Row(
                                          children: List.generate(_totalDays, (colIndex) {
                                            final date = dates[colIndex];
                                            final isToday = DateUtils.isSameDay(date, DateTime.now());
                                            return Container(
                                              width: _dayColumnWidth,
                                              height: _rowHeight,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: isDark ? Colors.white10 : AppColors.softGrey.withValues(alpha: 0.5),
                                                  ),
                                                  bottom: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                                                ),
                                                color: isToday ? AppColors.champagneGold.withValues(alpha: 0.05) : null,
                                              ),
                                            );
                                          }),
                                        ),

                                        // Absolute Positioned Booking Bars
                                        ...roomBookings.map((booking) {
                                          final checkIn = DateTime.parse(booking.checkIn);
                                          final checkOut = DateTime.parse(booking.checkOut);

                                          double startDaysOffset = checkIn.difference(_startDate).inHours / 24.0;
                                          double durationDays = checkOut.difference(checkIn).inHours / 24.0;

                                          if (startDaysOffset < 0) {
                                            durationDays += startDaysOffset;
                                            startDaysOffset = 0;
                                          }

                                          if (startDaysOffset + durationDays > _totalDays) {
                                            durationDays = _totalDays - startDaysOffset;
                                          }

                                          final double left = startDaysOffset * _dayColumnWidth + 2;
                                          final double width = (durationDays * _dayColumnWidth) - 4;

                                          final color = _getStatusColor(booking.statutBooking);

                                          return Positioned(
                                            left: left,
                                            top: 10,
                                            width: width,
                                            height: _rowHeight - 20,
                                            child: GestureDetector(
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
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                  color: color.withValues(alpha: 0.85),
                                                  border: Border.all(color: color, width: 1),
                                                ),
                                                child: Text(
                                                  booking.clientNom,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
