import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';

class CartItemEntity {
  final RoomEntity room;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool extraBedIncluded;
  final bool breakfastIncluded;
  final int breakfastCount;
  final bool isSelected;

  const CartItemEntity({
    required this.room,
    required this.checkIn,
    required this.checkOut,
    this.extraBedIncluded = false,
    this.breakfastIncluded = true,
    this.breakfastCount = 1,
    this.isSelected = true,
  });

  CartItemEntity copyWith({
    RoomEntity? room,
    DateTime? checkIn,
    DateTime? checkOut,
    bool? extraBedIncluded,
    bool? breakfastIncluded,
    int? breakfastCount,
    bool? isSelected,
  }) {
    return CartItemEntity(
      room: room ?? this.room,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      extraBedIncluded: extraBedIncluded ?? this.extraBedIncluded,
      breakfastIncluded: breakfastIncluded ?? this.breakfastIncluded,
      breakfastCount: breakfastCount ?? this.breakfastCount,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  int get nightsCount {
    final diff = checkOut.difference(checkIn).inDays;
    return diff <= 0 ? 1 : diff;
  }

  /// Calcul du coût de la chambre (petit-déjeuner offert)
  double get itemTotal {
    return room.prixNuit * nightsCount;
  }

  List<Object?> get props => [room, checkIn, checkOut, extraBedIncluded, breakfastIncluded, breakfastCount, isSelected];
}

