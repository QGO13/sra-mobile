import '../../domain/entities/equipment.dart';

class EquipmentModel extends Equipment {
  EquipmentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.status,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['status'] ?? 'AVAILABLE').toString().toUpperCase();
    String normalizedStatus = 'AVAILABLE';
    if (rawStatus == 'UNAVAILABLE' || rawStatus == 'MAUVAIS_ETAT' || rawStatus == 'INDISPONIBLE') {
      normalizedStatus = 'UNAVAILABLE';
    } else {
      normalizedStatus = 'AVAILABLE';
    }

    return EquipmentModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: normalizedStatus,
    );
  }

  Map<String, dynamic> toJson() {
    final backendStatus = status == 'AVAILABLE' ? 'BON_ETAT' : 'MAUVAIS_ETAT';
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': backendStatus,
    };
  }
}
