import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';

class UpdateRoomTypeUseCase {
  final RoomRepository repository;
  UpdateRoomTypeUseCase(this.repository);

  Future<RoomType> call(RoomType type, {XFile? imageFile}) async {
    return await repository.updateRoomType(type, imageFile: imageFile);
  }
}
