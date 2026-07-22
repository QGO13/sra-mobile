import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';

class GetReceptionRoomsUseCase {
  final ReceptionRepository repository;
  GetReceptionRoomsUseCase(this.repository);

  Future<List<Room>> call() async {
    return await repository.getRooms();
  }
}
