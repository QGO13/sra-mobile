import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository repository;
  CancelBookingUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.cancelBooking(id);
  }
}
