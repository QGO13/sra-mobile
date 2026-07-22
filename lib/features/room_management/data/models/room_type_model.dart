import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';

class RoomTypeModel extends RoomType {
  RoomTypeModel({
    required super.id,
    required super.nom,
    required super.prixNuit,
    required super.capacite,
    required super.description,
    required super.images,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      id: (json['id'] ?? json['id_type_de_chambre'] ?? '').toString(),
      nom: (json['name'] ?? json['nom'] ?? 'Chambre').toString(),
      prixNuit: double.tryParse((json['price_per_night'] ?? json['prix_nuit'] ?? 60000.0).toString()) ?? 60000.0,
      capacite: (json['capacity'] ?? json['capacite'] ?? 2) as int,
      description: json['description'] as String? ?? '',
      images: json['images'] != null
          ? (json['images'] as List).map<String>((img) {
              if (img is Map<String, dynamic>) {
                return (img['url'] ?? '').toString();
              }
              return img.toString();
            }).toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prix_nuit': prixNuit,
      'capacite': capacite,
      'description': description,
      'images': images,
    };
  }

  RoomTypeModel copyWith({
    String? id,
    String? nom,
    double? prixNuit,
    int? capacite,
    String? description,
    List<String>? images,
  }) {
    return RoomTypeModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prixNuit: prixNuit ?? this.prixNuit,
      capacite: capacite ?? this.capacite,
      description: description ?? this.description,
      images: images ?? this.images,
    );
  }
}
