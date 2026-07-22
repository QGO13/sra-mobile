import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';

class BookingRoomModel extends BookingRoom {
  const BookingRoomModel({
    required super.id,
    required super.numero,
    required super.idTypeDeChambre,
    required super.statut,
    required super.prixNuit,
    super.imageUrl,
  });

  factory BookingRoomModel.fromJson(Map<String, dynamic> json) {
    final roomType = json['room_type'] as Map<String, dynamic>?;
    final price = roomType != null ? (double.tryParse(roomType['price_per_night'].toString()) ?? 60000.0) : 60000.0;

    String? firstImg;
    if (roomType != null && roomType['images'] != null) {
      final imgs = roomType['images'] as List;
      if (imgs.isNotEmpty) {
        final imgItem = imgs.first;
        if (imgItem is Map<String, dynamic>) {
          firstImg = (imgItem['url'] ?? '').toString();
        } else {
          firstImg = imgItem.toString();
        }
      }
    }

    return BookingRoomModel(
      id: (json['id'] ?? json['id_chambre'] ?? '').toString(),
      numero: (json['number'] ?? json['numero'] ?? '').toString(),
      idTypeDeChambre: (json['room_type_id'] ?? json['id_type_de_chambre'] ?? '').toString(),
      statut: (json['etat'] ?? json['statut_menage'] ?? json['statut'] ?? 'A_NETTOYER').toString(),
      prixNuit: (json['prix_nuit'] ?? price).toDouble(),
      imageUrl: firstImg,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_chambre': id,
      'numero': numero,
      'id_type_de_chambre': idTypeDeChambre,
      'statut': statut,
      'prix_nuit': prixNuit,
      'image_url': imageUrl,
    };
  }
}
