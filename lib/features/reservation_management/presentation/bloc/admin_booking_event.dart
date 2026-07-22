import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';

abstract class AdminBookingEvent {}

class LoadAdminBookingsEvent extends AdminBookingEvent {}

class CancelAdminBookingEvent extends AdminBookingEvent {
  final String id;
  CancelAdminBookingEvent(this.id);
}

class ValidateAdminBookingEvent extends AdminBookingEvent {
  final Booking booking;
  ValidateAdminBookingEvent(this.booking);
}

class UpdateBookingLineEvent extends AdminBookingEvent {
  final String bookingId;
  final String lineId;
  final double price;
  UpdateBookingLineEvent({required this.bookingId, required this.lineId, required this.price});
}

class ApplyGlobalDiscountEvent extends AdminBookingEvent {
  final String bookingId;
  final double discountPercentage;
  ApplyGlobalDiscountEvent({required this.bookingId, required this.discountPercentage});
}

class PayBookingEvent extends AdminBookingEvent {
  final String bookingId;
  final double amount;
  final String paymentMethod;
  PayBookingEvent({required this.bookingId, required this.amount, required this.paymentMethod});
}
