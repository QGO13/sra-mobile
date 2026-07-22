import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class GetRoomTypesUseCase {
  final RoomRepository repository;
  GetRoomTypesUseCase(this.repository);

  Future<List<RoomType>> call() async {
    return await repository.getRoomTypes();
  }
}
