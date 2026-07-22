import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class EditAssignmentDialog extends StatefulWidget {
  final Booking booking;
  final List<Room> rooms;
  final List<Booking> bookings;
  final Function(Booking) onSave;

  const EditAssignmentDialog({
    super.key,
    required this.booking,
    required this.rooms,
    required this.bookings,
    required this.onSave,
  });

  @override
  State<EditAssignmentDialog> createState() => _EditAssignmentDialogState();
}

class _EditAssignmentDialogState extends State<EditAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late DateTime _checkIn;
  late DateTime _checkOut;
  late String _status;
  String? _selectedRoomNumber;
  String? _selectedRoomId;
  bool _filterByRoomType = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.booking.clientNom);
    _checkIn = DateTime.tryParse(widget.booking.checkIn) ?? DateTime.now();
    _checkOut = DateTime.tryParse(widget.booking.checkOut) ?? DateTime.now().add(const Duration(days: 1));
    final rawStatus = widget.booking.statutBooking.toUpperCase();
    if (rawStatus == 'CONFIRMEE') {
      _status = 'CONFIRME';
    } else if (rawStatus == 'ANNULEE') {
      _status = 'ANNULE';
    } else {
      _status = rawStatus;
    }
    
    final currentRoomNumber = widget.booking.lines.isNotEmpty ? widget.booking.lines[0].roomNumber : null;
    if (currentRoomNumber != null) {
      _selectedRoomNumber = currentRoomNumber;
      Room? match;
      for (final r in widget.rooms) {
        if (r.numero == currentRoomNumber) {
          match = r;
          break;
        }
      }
      if (match != null) {
        _selectedRoomId = match.id;
      } else if (widget.rooms.isNotEmpty) {
        _selectedRoomId = widget.rooms.first.id;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Room> _getAvailableRooms() {
    return widget.rooms.where((room) {
      // 1. Optional filter by room type name
      if (_filterByRoomType) {
        final bookingType = widget.booking.typeChambre.toLowerCase();
        final roomType = room.type.toLowerCase();
        // Check if types match roughly (e.g. Suite contains Suite, Premium contains Premium)
        if (!roomType.contains(bookingType) && !bookingType.contains(roomType)) {
          return false;
        }
      }

      // 2. Check for date overlaps with other ACTIVE reservations in this room
      for (final b in widget.bookings) {
        if (b.id == widget.booking.id) continue;
        if (b.statutBooking == 'ANNULE' || b.statutBooking == 'ANNULEE') continue;

        final assignedRoom = b.lines.isNotEmpty ? b.lines[0].roomNumber : null;
        if (assignedRoom == room.numero) {
          final bIn = DateTime.tryParse(b.checkIn);
          final bOut = DateTime.tryParse(b.checkOut);
          if (bIn != null && bOut != null) {
            // Overlap: A starts before B ends AND A ends after B starts
            if (_checkIn.isBefore(bOut) && _checkOut.isAfter(bIn)) {
              return false; // Room is occupied
            }
          }
        }
      }
      return true;
    }).toList();
  }

  Future<void> _selectCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => _buildThemeDatePicker(child),
    );
    if (picked != null) {
      setState(() {
        _checkIn = picked;
        if (_checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
        _selectedRoomNumber = null;
        _selectedRoomId = null;
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOut,
      firstDate: _checkIn.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => _buildThemeDatePicker(child),
    );
    if (picked != null) {
      setState(() {
        _checkOut = picked;
        _selectedRoomNumber = null;
        _selectedRoomId = null;
      });
    }
  }

  Widget _buildThemeDatePicker(Widget? child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Theme(
      data: theme.copyWith(
        colorScheme: isDark
            ? const ColorScheme.dark(
                primary: AppColors.champagneGold,
                onPrimary: Colors.black,
                surface: AppColors.imperialNightBlue,
                onSurface: Colors.white,
              )
            : const ColorScheme.light(
                primary: AppColors.champagneGold,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: AppColors.imperialNightBlue,
              ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final availableRooms = _getAvailableRooms();

    // Ensure currently selected room is included in dropdown even if it overlaps (to avoid crash)
    final bool currentRoomAvailable = _selectedRoomNumber == null || availableRooms.any((r) => r.numero == _selectedRoomNumber);
    final List<Room> dropdownRooms = [...availableRooms];
    if (!currentRoomAvailable && _selectedRoomNumber != null) {
      Room? currentRoom;
      for (final r in widget.rooms) {
        if (r.numero == _selectedRoomNumber) {
          currentRoom = r;
          break;
        }
      }
      if (currentRoom != null) {
        dropdownRooms.add(currentRoom);
      }
    }

    return AlertDialog(
      title: Text(
        l10n.editBookingTitle,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
      ),
      backgroundColor: isDark ? AppColors.imperialNightBlue : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Name
              SraInput(
                controller: _nameController,
                label: l10n.occupantName,
                placeholder: "e.g. Jean Dupont",
                validator: (val) => val == null || val.trim().isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // Dates Row
              Row(
                children: [
                  // Check-in
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.checkInDate.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.8,
                            color: AppColors.champagneGold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectCheckInDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.deepBlue : Colors.white,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                              border: Border.all(color: isDark ? Colors.white12 : AppColors.softGrey, width: 1.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat.yMd(Localizations.localeOf(context).toString()).format(_checkIn),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const Icon(Icons.calendar_today, size: 16, color: AppColors.champagneGold),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  // Check-out
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.checkOutDate.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.8,
                            color: AppColors.champagneGold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectCheckOutDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.deepBlue : Colors.white,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                              border: Border.all(color: isDark ? Colors.white12 : AppColors.softGrey, width: 1.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat.yMd(Localizations.localeOf(context).toString()).format(_checkOut),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const Icon(Icons.calendar_today, size: 16, color: AppColors.champagneGold),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // Filter check-box for Room Type
              CheckboxListTile(
                value: _filterByRoomType,
                onChanged: (val) {
                  setState(() {
                    _filterByRoomType = val ?? true;
                    _selectedRoomNumber = null;
                    _selectedRoomId = null;
                  });
                },
                title: Text(
                  l10n.restrictToTypology(widget.booking.typeChambre),
                  style: const TextStyle(fontSize: 12),
                ),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.champagneGold,
                controlAffinity: ListTileControlAffinity.leading,
              ),

              // Room Selection Dropdown
              Text(
                l10n.assignedRoom.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: AppColors.champagneGold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: ValueKey('room_dropdown_${_checkIn.millisecondsSinceEpoch}_${_checkOut.millisecondsSinceEpoch}'),
                initialValue: _selectedRoomNumber,
                validator: (val) => val == null ? l10n.requiredField : null,
                dropdownColor: isDark ? AppColors.imperialNightBlue : Colors.white,
                menuMaxHeight: 300,
                iconEnabledColor: AppColors.champagneGold,
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : AppColors.imperialNightBlue),
                decoration: InputDecoration(
                  hintText: l10n.selectRoomPlaceholder,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                  fillColor: isDark ? AppColors.deepBlue : Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : AppColors.softGrey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.champagneGold,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
                items: dropdownRooms.map((room) {
                  final isCurrent = room.numero == widget.booking.lines.firstOrNull?.roomNumber;
                  final isOverlap = !availableRooms.any((r) => r.numero == room.numero);
                  return DropdownMenuItem<String>(
                    value: room.numero,
                    child: Text(
                      "${l10n.room} ${room.numero} (${room.type})${isCurrent ? ' - ${l10n.currentRoomLabel}' : ''}${isOverlap ? ' (${l10n.overlapWarning})' : ''}",
                      style: TextStyle(
                        color: isOverlap ? AppColors.statusError : null,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    Room? match;
                    for (final r in widget.rooms) {
                      if (r.numero == val) {
                        match = r;
                        break;
                      }
                    }
                    if (match != null) {
                      final matchId = match.id;
                      setState(() {
                        _selectedRoomNumber = val;
                        _selectedRoomId = matchId;
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // Status Dropdown
              Text(
                l10n.statusLabel.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: AppColors.champagneGold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _status,
                dropdownColor: isDark ? AppColors.imperialNightBlue : Colors.white,
                iconEnabledColor: AppColors.champagneGold,
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : AppColors.imperialNightBlue),
                decoration: InputDecoration(
                  fillColor: isDark ? AppColors.deepBlue : Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? Colors.white12 : AppColors.softGrey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.champagneGold,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
                items: (() {
                  final allowed = {'EN_ATTENTE', 'CONFIRME', 'EFFECTUE', 'TERMINEE', 'ANNULE'};
                  final list = [
                    DropdownMenuItem(value: 'EN_ATTENTE', child: Text(l10n.pendingStatus)),
                    DropdownMenuItem(value: 'CONFIRME', child: Text(l10n.confirmedStatus)),
                    DropdownMenuItem(value: 'EFFECTUE', child: Text(l10n.effectueStatus)),
                    DropdownMenuItem(value: 'TERMINEE', child: Text(l10n.completedStatus)),
                    DropdownMenuItem(value: 'ANNULE', child: Text(l10n.cancelledStatus)),
                  ];
                  if (!allowed.contains(_status)) {
                    list.add(DropdownMenuItem(value: _status, child: Text(_status)));
                  }
                  return list;
                })(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _status = val;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        SraButton(
          label: l10n.cancelLabel,
          isOutlined: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        SraButton(
          label: l10n.confirmLabel,
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedRoomNumber != null) {
              final originalLine = widget.booking.lines.isNotEmpty 
                  ? widget.booking.lines[0] 
                  : const BookingLine(id: '', roomTypeName: '', price: 0.0, checkIn: '', checkOut: '');
              
              String type = originalLine.roomTypeName;
              for (final r in widget.rooms) {
                if (r.numero == _selectedRoomNumber) {
                  type = r.type;
                  break;
                }
              }
              
              final updatedLine = BookingLine(
                id: originalLine.id,
                roomTypeName: type,
                price: originalLine.price,
                checkIn: DateFormat('yyyy-MM-dd').format(_checkIn),
                checkOut: DateFormat('yyyy-MM-dd').format(_checkOut),
                occupantName: _nameController.text.trim(),
                roomNumber: _selectedRoomNumber,
                chambreId: _selectedRoomId,
              );
 
              final updatedBooking = Booking(
                id: widget.booking.id,
                reference: widget.booking.reference,
                clientNom: _nameController.text.trim(),
                typeChambre: updatedLine.roomTypeName,
                checkIn: DateFormat('yyyy-MM-dd').format(_checkIn),
                checkOut: DateFormat('yyyy-MM-dd').format(_checkOut),
                adultes: widget.booking.adultes,
                enfants: widget.booking.enfants,
                statutBooking: _status,
                prixTotal: widget.booking.prixTotal,
                lines: [updatedLine],
              );
 
              widget.onSave(updatedBooking);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
