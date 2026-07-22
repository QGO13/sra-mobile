import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';

class BookingRoomTypeModel extends BookingRoomType {
  const BookingRoomTypeModel({
    required super.id,
    required super.nom,
    required super.prixNuit,
    required super.capacite,
    required super.description,
    required super.images,
    required super.equipments,
  });

  factory BookingRoomTypeModel.fromJson(Map<String, dynamic> json) {
    return BookingRoomTypeModel(
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
      equipments: json['room_type_equipments'] != null
          ? (json['room_type_equipments'] as List).map<String>((eq) {
              if (eq is Map<String, dynamic>) {
                final equipment = eq['equipment'] as Map<String, dynamic>?;
                if (equipment != null) {
                  return (equipment['name'] ?? '').toString();
                }
              }
              return '';
            }).where((name) => name.isNotEmpty).toList()
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
      'equipments': equipments,
    };
  }
}
