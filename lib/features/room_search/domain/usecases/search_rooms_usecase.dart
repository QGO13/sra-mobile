import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';
import 'package:sra_hotel/features/room_search/domain/repositories/booking_repository.dart';

class SearchRoomsParams {
  final DateTime checkIn;
  final DateTime checkOut;
  final String? categoryId;

  const SearchRoomsParams({
    required this.checkIn,
    required this.checkOut,
    this.categoryId,
  });
}

class SearchRoomsUseCase {
  final BookingRepository repository;

  SearchRoomsUseCase(this.repository);

  Future<List<RoomEntity>> call(SearchRoomsParams params) async {
    return await repository.searchAvailableRooms(
      checkIn: params.checkIn,
      checkOut: params.checkOut,
      categoryId: params.categoryId,
    );
  }
}

