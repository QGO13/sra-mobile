import 'package:sra_hotel/features/reservation_management/data/datasources/booking_remote_data_source.dart';
import 'package:sra_hotel/features/reservation_management/data/models/booking_model.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Booking>> getBookings() async {
    return await remoteDataSource.getBookings();
  }

  @override
  Future<Booking> updateBooking(Booking booking) async {
    return await remoteDataSource.updateBooking(
      BookingModel(
        id: booking.id,
        reference: booking.reference,
        clientNom: booking.clientNom,
        typeChambre: booking.typeChambre,
        checkIn: booking.checkIn,
        checkOut: booking.checkOut,
        adultes: booking.adultes,
        enfants: booking.enfants,
        statutBooking: booking.statutBooking,
        prixTotal: booking.prixTotal,
        lines: booking.lines,
      ),
    );
  }

  @override
  Future<void> cancelBooking(String id) async {
    await remoteDataSource.cancelBooking(id);
  }

  @override
  Future<Booking> updateBookingLine(String bookingId, String lineId, {required double price}) async {
    return await remoteDataSource.updateBookingLine(bookingId, lineId, price: price);
  }

  @override
  Future<Booking> applyGlobalDiscount(String bookingId, {required double discountPercentage}) async {
    return await remoteDataSource.applyGlobalDiscount(bookingId, discountPercentage: discountPercentage);
  }

  @override
  Future<void> payBooking(String bookingId, {required double amount, required String paymentMethod}) async {
    await remoteDataSource.payBooking(bookingId, amount: amount, paymentMethod: paymentMethod);
  }
}
