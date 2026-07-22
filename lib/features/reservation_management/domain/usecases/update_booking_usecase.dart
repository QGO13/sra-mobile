import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class UpdateBookingUseCase {
  final BookingRepository repository;
  UpdateBookingUseCase(this.repository);

  Future<Booking> call(Booking booking) async {
    return await repository.updateBooking(booking);
  }
}
