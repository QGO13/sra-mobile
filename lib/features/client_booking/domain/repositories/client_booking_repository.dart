import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';

abstract class ClientBookingRepository {
  Future<List<BookingRoomType>> getRoomTypes({DateTime? checkIn, DateTime? checkOut});
  Future<List<BookingRoom>> getAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
  });
}
