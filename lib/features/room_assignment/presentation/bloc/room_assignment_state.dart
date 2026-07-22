import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';

abstract class RoomAssignmentState {}

class RoomAssignmentInitial extends RoomAssignmentState {}

class RoomAssignmentLoading extends RoomAssignmentState {}

class RoomAssignmentLoaded extends RoomAssignmentState {
  final List<Room> rooms;
  final List<Booking> bookings;

  RoomAssignmentLoaded({required this.rooms, required this.bookings});
}

class RoomAssignmentError extends RoomAssignmentState {
  final String message;
  RoomAssignmentError(this.message);
}

class RoomAssignmentActionSuccess extends RoomAssignmentState {
  final String message;
  RoomAssignmentActionSuccess(this.message);
}
