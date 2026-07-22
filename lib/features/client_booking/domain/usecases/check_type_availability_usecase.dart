import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';

class CheckTypeAvailabilityParams {
  final DateTime checkIn;
  final DateTime checkOut;

  const CheckTypeAvailabilityParams({
    required this.checkIn,
    required this.checkOut,
  });
}

class CheckTypeAvailabilityUseCase {
  final ClientBookingRepository repository;

  CheckTypeAvailabilityUseCase(this.repository);

  Future<List<BookingRoom>> call(CheckTypeAvailabilityParams params) async {
    return await repository.getAvailableRooms(
      checkIn: params.checkIn,
      checkOut: params.checkOut,
    );
  }
}
