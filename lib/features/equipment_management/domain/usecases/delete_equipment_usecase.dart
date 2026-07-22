import '../repositories/equipment_repository.dart';

class DeleteEquipmentUseCase {
  final EquipmentRepository repository;

  DeleteEquipmentUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.deleteEquipment(id);
  }
}
