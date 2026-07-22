import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<Room> createRoom(Room room);
  Future<Room> updateRoom(Room room);
  Future<void> deleteRoom(String id);

  Future<List<RoomType>> getRoomTypes();
  Future<RoomType> createRoomType(RoomType type, {XFile? imageFile});
  Future<RoomType> updateRoomType(RoomType type, {XFile? imageFile});
  Future<void> deleteRoomType(String id);
}
