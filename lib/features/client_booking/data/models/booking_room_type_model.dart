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
    super.availableCount,
  });

  factory BookingRoomTypeModel.fromJson(Map<String, dynamic> json) {
    int parsedAvailableCount = 1;
    if (json['available_count'] != null) {
      parsedAvailableCount = (json['available_count'] as num).toInt();
    } else if (json['rooms'] != null && json['rooms'] is List) {
      parsedAvailableCount = (json['rooms'] as List).length;
    }

    return BookingRoomTypeModel(
      id: (json['id'] ?? json['id_type_de_chambre'] ?? '').toString(),
      nom: (json['name'] ?? json['nom'] ?? 'Chambre').toString(),
      prixNuit: double.tryParse((json['price_per_night'] ?? json['prix_nuit'] ?? 60000.0).toString()) ?? 60000.0,
      capacite: (json['capacity'] ?? json['capacite'] ?? 2) as int,
      description: json['description'] as String? ?? '',
      availableCount: parsedAvailableCount,
      images: json['images'] != null
          ? (json['images'] as List).map<String>((img) {
              if (img is Map<String, dynamic>) {
                final url = (img['url'] ?? '').toString();
                if (url.startsWith('/')) {
                  return 'http://192.168.10.246:8000$url';
                }
                return url;
              }
              return img.toString();
            }).toList()
          : const [],
      equipments: json['room_type_equipments'] != null
          ? (json['room_type_equipments'] as List).map<String>((eq) {
              if (eq is Map<String, dynamic>) {
                final equipment = (eq['equipment_type'] ?? eq['equipment']) as Map<String, dynamic>?;
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
      'available_count': availableCount,
      'images': images,
      'equipments': equipments,
    };
  }
}
