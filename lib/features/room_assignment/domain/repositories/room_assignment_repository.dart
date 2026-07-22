import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';

abstract class RoomAssignmentRepository {
  Future<List<Booking>> getBookings();
  Future<List<Room>> getRooms();
  Future<Booking> updateBooking(Booking booking);
}
