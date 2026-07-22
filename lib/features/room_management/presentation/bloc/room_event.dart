import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';

abstract class RoomEvent {}

class LoadRoomsAndTypesEvent extends RoomEvent {}

class CreateRoomEvent extends RoomEvent {
  final Room room;
  CreateRoomEvent(this.room);
}

class UpdateRoomEvent extends RoomEvent {
  final Room room;
  UpdateRoomEvent(this.room);
}

class DeleteRoomEvent extends RoomEvent {
  final String id;
  DeleteRoomEvent(this.id);
}

class CreateRoomTypeEvent extends RoomEvent {
  final RoomType type;
  final XFile? imageFile;
  CreateRoomTypeEvent(this.type, {this.imageFile});
}

class UpdateRoomTypeEvent extends RoomEvent {
  final RoomType type;
  final XFile? imageFile;
  UpdateRoomTypeEvent(this.type, {this.imageFile});
}

class DeleteRoomTypeEvent extends RoomEvent {
  final String id;
  DeleteRoomTypeEvent(this.id);
}
