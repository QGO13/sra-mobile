import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class GetBookingsUseCase {
  final BookingRepository repository;
  GetBookingsUseCase(this.repository);

  Future<List<Booking>> call() async {
    return await repository.getBookings();
  }
}
