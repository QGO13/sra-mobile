import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';

abstract class BookingState {
  const BookingState();

  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class RoomsLoadSuccess extends BookingState {
  final List<RoomEntity> rooms;

  const RoomsLoadSuccess(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

class RoomVerificationSuccess extends BookingState {
  final String roomId;
  final bool isAvailable;
  final String message;

  const RoomVerificationSuccess({
    required this.roomId,
    required this.isAvailable,
    required this.message,
  });

  @override
  List<Object?> get props => [roomId, isAvailable, message];
}

class BookingFailure extends BookingState {
  final String message;

  const BookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

