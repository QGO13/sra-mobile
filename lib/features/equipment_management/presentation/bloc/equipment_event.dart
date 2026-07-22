import '../../domain/entities/equipment.dart';

abstract class EquipmentEvent {}

class LoadEquipmentsEvent extends EquipmentEvent {}

class CreateEquipmentEvent extends EquipmentEvent {
  final Equipment equipment;
  CreateEquipmentEvent(this.equipment);
}

class UpdateEquipmentEvent extends EquipmentEvent {
  final Equipment equipment;
  UpdateEquipmentEvent(this.equipment);
}

class DeleteEquipmentEvent extends EquipmentEvent {
  final String id;
  DeleteEquipmentEvent(this.id);
}
