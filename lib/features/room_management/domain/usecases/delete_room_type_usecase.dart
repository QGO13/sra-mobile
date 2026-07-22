import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class DeleteRoomTypeUseCase {
  final RoomRepository repository;
  DeleteRoomTypeUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteRoomType(id);
  }
}
