import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';

class GetBookingRoomTypesUseCase {
  final ClientBookingRepository repository;

  GetBookingRoomTypesUseCase(this.repository);

  Future<List<BookingRoomType>> call() async {
    return await repository.getRoomTypes();
  }
}
