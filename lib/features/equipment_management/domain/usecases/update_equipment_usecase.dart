import '../entities/equipment.dart';
import '../repositories/equipment_repository.dart';

class UpdateEquipmentUseCase {
  final EquipmentRepository repository;

  UpdateEquipmentUseCase({required this.repository});

  Future<Equipment> call(Equipment equipment) async {
    return await repository.updateEquipment(equipment);
  }
}
