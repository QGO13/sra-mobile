import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();
  Future<Booking> updateBooking(Booking booking);
  Future<void> cancelBooking(String id);
  Future<Booking> updateBookingLine(String bookingId, String lineId, {required double price});
  Future<Booking> applyGlobalDiscount(String bookingId, {required double discountPercentage});
  Future<void> payBooking(String bookingId, {required double amount, required String paymentMethod});
}
