import '../entities/equipment.dart';
import '../repositories/equipment_repository.dart';

class GetEquipmentsUseCase {
  final EquipmentRepository repository;

  GetEquipmentsUseCase({required this.repository});

  Future<List<Equipment>> call() async {
    return await repository.getEquipments();
  }
}
