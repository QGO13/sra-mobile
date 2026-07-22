import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class GetRoomsUseCase {
  final RoomRepository repository;
  GetRoomsUseCase(this.repository);

  Future<List<Room>> call() async {
    return await repository.getRooms();
  }
}
