import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class DeleteRoomUseCase {
  final RoomRepository repository;
  DeleteRoomUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteRoom(id);
  }
}
