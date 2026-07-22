import '../entities/equipment.dart';

abstract class EquipmentRepository {
  Future<List<Equipment>> getEquipments();
  Future<Equipment> createEquipment(Equipment equipment);
  Future<Equipment> updateEquipment(Equipment equipment);
  Future<void> deleteEquipment(String id);
}
