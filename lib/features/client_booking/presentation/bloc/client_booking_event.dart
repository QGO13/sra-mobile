import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';

abstract class ClientBookingEvent {
  const ClientBookingEvent();

  List<Object?> get props => [];
}

class LoadRoomTypesEvent extends ClientBookingEvent {
  final DateTime? checkIn;
  final DateTime? checkOut;

  const LoadRoomTypesEvent({this.checkIn, this.checkOut});

  @override
  List<Object?> get props => [checkIn, checkOut];
}

class SelectRoomTypeEvent extends ClientBookingEvent {
  final BookingRoomType roomType;

  const SelectRoomTypeEvent(this.roomType);

  @override
  List<Object?> get props => [roomType];
}

class SelectDatesEvent extends ClientBookingEvent {
  final DateTime checkIn;
  final DateTime checkOut;

  const SelectDatesEvent({required this.checkIn, required this.checkOut});

  @override
  List<Object?> get props => [checkIn, checkOut];
}

class ConfirmQuantityEvent extends ClientBookingEvent {
  final int quantity;
  final bool continueBooking;

  const ConfirmQuantityEvent({required this.quantity, required this.continueBooking});

  @override
  List<Object?> get props => [quantity, continueBooking];
}

class ResetBookingFlowEvent extends ClientBookingEvent {}
