import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';

abstract class RoomAssignmentEvent {}

class LoadRoomAssignmentDataEvent extends RoomAssignmentEvent {}

class UpdateBookingAssignmentEvent extends RoomAssignmentEvent {
  final Booking booking;
  UpdateBookingAssignmentEvent(this.booking);
}

class CancelBookingAssignmentEvent extends RoomAssignmentEvent {
  final Booking booking;
  CancelBookingAssignmentEvent(this.booking);
}
