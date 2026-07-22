import '../../domain/entities/equipment.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../datasources/equipment_remote_data_source.dart';
import '../models/equipment_model.dart';

class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentRemoteDataSource remoteDataSource;

  EquipmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Equipment>> getEquipments() async {
    return await remoteDataSource.getEquipments();
  }

  @override
  Future<Equipment> createEquipment(Equipment equipment) async {
    return await remoteDataSource.createEquipment(
      EquipmentModel(
        id: equipment.id,
        name: equipment.name,
        description: equipment.description,
        status: equipment.status,
      ),
    );
  }

  @override
  Future<Equipment> updateEquipment(Equipment equipment) async {
    return await remoteDataSource.updateEquipment(
      EquipmentModel(
        id: equipment.id,
        name: equipment.name,
        description: equipment.description,
        status: equipment.status,
      ),
    );
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await remoteDataSource.deleteEquipment(id);
  }
}
