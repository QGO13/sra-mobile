import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class PayBookingUseCase {
  final BookingRepository repository;
  PayBookingUseCase(this.repository);

  Future<void> call(String bookingId, {required double amount, required String paymentMethod}) async {
    await repository.payBooking(bookingId, amount: amount, paymentMethod: paymentMethod);
  }
}
