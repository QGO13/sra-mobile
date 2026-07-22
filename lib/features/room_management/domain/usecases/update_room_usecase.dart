import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class UpdateRoomUseCase {
  final RoomRepository repository;
  UpdateRoomUseCase(this.repository);

  Future<Room> call(Room room) async {
    return await repository.updateRoom(room);
  }
}
