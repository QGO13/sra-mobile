import '../../domain/entities/equipment.dart';

abstract class EquipmentState {}

class EquipmentInitial extends EquipmentState {}

class EquipmentLoading extends EquipmentState {}

class EquipmentLoaded extends EquipmentState {
  final List<Equipment> equipments;
  EquipmentLoaded(this.equipments);
}

class EquipmentFailure extends EquipmentState {
  final String error;
  EquipmentFailure(this.error);
}
