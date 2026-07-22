import '../entities/equipment.dart';
import '../repositories/equipment_repository.dart';

class CreateEquipmentUseCase {
  final EquipmentRepository repository;

  CreateEquipmentUseCase({required this.repository});

  Future<Equipment> call(Equipment equipment) async {
    return await repository.createEquipment(equipment);
  }
}
