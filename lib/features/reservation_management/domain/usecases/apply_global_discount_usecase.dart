import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class ApplyGlobalDiscountUseCase {
  final BookingRepository repository;
  ApplyGlobalDiscountUseCase(this.repository);

  Future<Booking> call(String bookingId, {required double discountPercentage}) async {
    return await repository.applyGlobalDiscount(bookingId, discountPercentage: discountPercentage);
  }
}
