import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';

class HotelServiceModel extends HotelService {
  HotelServiceModel({
    required super.id,
    required super.nom,
    required super.prix,
    required super.categorie,
    required super.description,
  });

  factory HotelServiceModel.fromJson(Map<String, dynamic> json) {
    return HotelServiceModel(
      id: json['id'] as int,
      nom: (json['nom'] ?? json['name'] ?? '').toString(),
      prix: ((json['prix'] ?? json['prix_unitaire'] ?? 0.0) as num).toDouble(),
      categorie: (json['categorie'] ?? 'AUTRE').toString(),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'name': nom,
      'prix': prix,
      'prix_unitaire': prix,
      'categorie': categorie,
      'description': description,
    };
  }

  HotelServiceModel copyWith({
    int? id,
    String? nom,
    double? prix,
    String? categorie,
    String? description,
  }) {
    return HotelServiceModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prix: prix ?? this.prix,
      categorie: categorie ?? this.categorie,
      description: description ?? this.description,
    );
  }
}
