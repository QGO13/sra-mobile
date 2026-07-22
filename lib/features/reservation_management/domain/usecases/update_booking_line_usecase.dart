import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class UpdateBookingLineUseCase {
  final BookingRepository repository;
  UpdateBookingLineUseCase(this.repository);

  Future<Booking> call(String bookingId, String lineId, {required double price}) async {
    return await repository.updateBookingLine(bookingId, lineId, price: price);
  }
}
