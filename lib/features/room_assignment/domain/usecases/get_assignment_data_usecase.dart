import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking_line.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/domain/repositories/room_assignment_repository.dart';

class AssignmentData {
  final List<Room> rooms;
  final List<Booking> bookings;

  AssignmentData({required this.rooms, required this.bookings});
}

class GetAssignmentDataUseCase {
  final RoomAssignmentRepository repository;

  GetAssignmentDataUseCase(this.repository);

  Future<AssignmentData> call() async {
    final results = await Future.wait([
      repository.getRooms(),
      repository.getBookings(),
    ]);

    final rooms = results[0] as List<Room>;
    final bookings = results[1] as List<Booking>;

    // Map chambreId to roomNumber dynamically for bookings lacking it
    final resolvedBookings = bookings.map((booking) {
      if (booking.lines.isEmpty) return booking;
      final line = booking.lines[0];
      
      // If roomNumber is already set, keep it
      if (line.roomNumber != null && line.roomNumber!.isNotEmpty) {
        return booking;
      }

      // Look up room number by chambreId
      if (line.chambreId != null) {
        final match = rooms.where((r) => r.id == line.chambreId).firstOrNull;
        if (match != null) {
          final updatedLine = BookingLine(
            id: line.id,
            roomTypeName: line.roomTypeName,
            price: line.price,
            checkIn: line.checkIn,
            checkOut: line.checkOut,
            occupantName: line.occupantName,
            roomNumber: match.numero,
            chambreId: line.chambreId,
          );
          return Booking(
            id: booking.id,
            reference: booking.reference,
            clientNom: booking.clientNom,
            typeChambre: booking.typeChambre,
            checkIn: booking.checkIn,
            checkOut: booking.checkOut,
            adultes: booking.adultes,
            enfants: booking.enfants,
            statutBooking: booking.statutBooking,
            prixTotal: booking.prixTotal,
            lines: [updatedLine],
          );
        }
      }
      return booking;
    }).toList();

    return AssignmentData(rooms: rooms, bookings: resolvedBookings);
  }
}
