import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';

abstract class BookingRepository {
  Future<List<RoomEntity>> searchAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
    String? categoryId,
  });

  Future<bool> verifyRoomAvailability({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  });
}

