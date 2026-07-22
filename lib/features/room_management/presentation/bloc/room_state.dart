import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';

abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;
  final List<RoomType> roomTypes;

  RoomLoaded({required this.rooms, required this.roomTypes});
}

class RoomFailure extends RoomState {
  final String error;
  RoomFailure(this.error);
}
