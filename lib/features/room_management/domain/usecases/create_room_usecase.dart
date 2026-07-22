import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class CreateRoomUseCase {
  final RoomRepository repository;
  CreateRoomUseCase(this.repository);

  Future<Room> call(Room room) async {
    return await repository.createRoom(room);
  }
}
