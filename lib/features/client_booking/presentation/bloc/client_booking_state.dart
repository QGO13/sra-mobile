import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';

abstract class ClientBookingState {
  const ClientBookingState();

  List<Object?> get props => [];
}

class ClientBookingInitial extends ClientBookingState {}

class RoomTypesLoadedState extends ClientBookingState {
  final List<BookingRoomType> roomTypes;

  const RoomTypesLoadedState(this.roomTypes);

  @override
  List<Object?> get props => [roomTypes];
}

class SelectingDatesState extends ClientBookingState {
  final BookingRoomType selectedType;

  const SelectingDatesState(this.selectedType);

  @override
  List<Object?> get props => [selectedType];
}

class CheckingAvailabilityState extends ClientBookingState {}

class AvailabilityResultState extends ClientBookingState {
  final BookingRoomType selectedType;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool isAvailable;
  final List<BookingRoom> availableRooms;
  final int maxQuantity;
  final List<BookingRoomType> alternatives;

  const AvailabilityResultState({
    required this.selectedType,
    required this.checkIn,
    required this.checkOut,
    required this.isAvailable,
    required this.availableRooms,
    required this.maxQuantity,
    required this.alternatives,
  });

  @override
  List<Object?> get props => [
        selectedType,
        checkIn,
        checkOut,
        isAvailable,
        availableRooms,
        maxQuantity,
        alternatives,
      ];
}

class BookingCompletedState extends ClientBookingState {
  final List<BookingRoom> roomsToAdd;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool continueBooking;

  const BookingCompletedState({
    required this.roomsToAdd,
    required this.checkIn,
    required this.checkOut,
    required this.continueBooking,
  });

  @override
  List<Object?> get props => [roomsToAdd, checkIn, checkOut, continueBooking];
}

class BookingErrorState extends ClientBookingState {
  final String message;

  const BookingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
