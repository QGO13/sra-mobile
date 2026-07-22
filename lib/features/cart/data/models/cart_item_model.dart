import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sra_hotel/features/room_search/data/models/room_model.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.room,
    required super.checkIn,
    required super.checkOut,
    super.extraBedIncluded,
    super.breakfastIncluded,
    super.breakfastCount,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      room: RoomModel.fromJson(json['room'] as Map<String, dynamic>),
      checkIn: DateTime.parse(json['check_in'].toString()),
      checkOut: DateTime.parse(json['check_out'].toString()),
      extraBedIncluded: json['extra_bed_included'] as bool? ?? false,
      breakfastIncluded: json['breakfast_included'] as bool? ?? false,
      breakfastCount: json['breakfast_count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': {
        'id': room.id,
        'number': room.numero,
        'room_type_id': room.idTypeDeChambre,
        'statut': room.statut,
        'prix_nuit': room.prixNuit,
        'image_url': room.imageUrl,
      },
      'check_in': checkIn.toIso8601String(),
      'check_out': checkOut.toIso8601String(),
      'extra_bed_included': extraBedIncluded,
      'breakfast_included': breakfastIncluded,
      'breakfast_count': breakfastCount,
    };
  }
}
