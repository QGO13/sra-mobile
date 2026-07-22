import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';

abstract class CartEvent {
  const CartEvent();

  List<Object?> get props => [];
}

class CartStarted extends CartEvent {}

class CartItemAdded extends CartEvent {
  final RoomEntity room;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool extraBedIncluded;

  const CartItemAdded(
    this.room, {
    required this.checkIn,
    required this.checkOut,
    this.extraBedIncluded = false,
  });

  @override
  List<Object?> get props => [room, checkIn, checkOut, extraBedIncluded];
}

class CartItemRemoved extends CartEvent {
  final String roomId;

  const CartItemRemoved(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class CartItemUpdated extends CartEvent {
  final String roomId;
  final bool? extraBedIncluded;
  final bool? breakfastIncluded;
  final int? breakfastCount;

  const CartItemUpdated(
    this.roomId, {
    this.extraBedIncluded,
    this.breakfastIncluded,
    this.breakfastCount,
  });

  @override
  List<Object?> get props => [roomId, extraBedIncluded, breakfastIncluded, breakfastCount];
}

class CartCleared extends CartEvent {}

class CartDatesUpdated extends CartEvent {
  final DateTime checkIn;
  final DateTime checkOut;

  const CartDatesUpdated({required this.checkIn, required this.checkOut});

  @override
  List<Object?> get props => [checkIn, checkOut];
}

