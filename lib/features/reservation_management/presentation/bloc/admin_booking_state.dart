import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';

abstract class AdminBookingState {}

class AdminBookingInitial extends AdminBookingState {}

class AdminBookingLoading extends AdminBookingState {}

class AdminBookingLoaded extends AdminBookingState {
  final List<Booking> bookings;
  AdminBookingLoaded(this.bookings);
}

class AdminBookingFailure extends AdminBookingState {
  final String error;
  AdminBookingFailure(this.error);
}
