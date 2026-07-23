import '../../domain/entities/equipment.dart';

class EquipmentModel extends Equipment {
  EquipmentModel({
    required super.id,
    required super.name,
    super.codeEq = '',
    super.quantity = 1,
    required super.description,
    required super.status,
    super.roomNumber,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['status'] ?? 'EN_SERVICE').toString().toUpperCase();
    
    String normalizedStatus = 'AVAILABLE';
    if (rawStatus == 'EN_SERVICE' || rawStatus == 'AVAILABLE' || rawStatus == 'BON_ETAT') {
      normalizedStatus = 'AVAILABLE';
    } else {
      normalizedStatus = 'UNAVAILABLE';
    }

    final roomObj = json['room'] as Map<String, dynamic>?;
    final roomNumStr = roomObj != null ? (roomObj['number'] ?? roomObj['numero'] ?? '').toString() : null;

    final nameVal = (json['code_eq'] ?? json['name'] ?? 'Équipement').toString();

    return EquipmentModel(
      id: (json['id'] ?? '').toString(),
      name: nameVal,
      codeEq: (json['code_eq'] ?? '').toString(),
      quantity: (json['quantity'] ?? 1) as int,
      description: (json['description'] ?? '').toString(),
      status: normalizedStatus,
      roomNumber: roomNumStr,
    );
  }

  Map<String, dynamic> toJson() {
    final backendStatus = status == 'AVAILABLE' ? 'EN_SERVICE' : 'HORS_SERVICE';
    return {
      'id': id,
      'code_eq': codeEq.isNotEmpty ? codeEq : name,
      'quantity': quantity,
      'description': description,
      'status': backendStatus,
    };
  }
}
