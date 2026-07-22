import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';

class CartItemEntity {
  final RoomEntity room;
  final DateTime checkIn;
  final DateTime checkOut;
  final bool extraBedIncluded;
  final bool breakfastIncluded;
  final int breakfastCount;

  const CartItemEntity({
    required this.room,
    required this.checkIn,
    required this.checkOut,
    this.extraBedIncluded = false,
    this.breakfastIncluded = false,
    this.breakfastCount = 1,
  });

  CartItemEntity copyWith({
    RoomEntity? room,
    DateTime? checkIn,
    DateTime? checkOut,
    bool? extraBedIncluded,
    bool? breakfastIncluded,
    int? breakfastCount,
  }) {
    return CartItemEntity(
      room: room ?? this.room,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      extraBedIncluded: extraBedIncluded ?? this.extraBedIncluded,
      breakfastIncluded: breakfastIncluded ?? this.breakfastIncluded,
      breakfastCount: breakfastCount ?? this.breakfastCount,
    );
  }

  int get nightsCount {
    final diff = checkOut.difference(checkIn).inDays;
    return diff <= 0 ? 1 : diff;
  }

  // Calculate room cost + select supplements per night, then multiply by nights
  double get itemTotal {
    double pricePerNight = room.prixNuit;
    if (extraBedIncluded && room.isSuite) {
      pricePerNight += 15000; // Extra bed cost (15,000 FCFA/night)
    }
    if (breakfastIncluded) {
      pricePerNight += breakfastCount * 5000; // Breakfast cost (5,000 FCFA/person/night)
    }
    return pricePerNight * nightsCount;
  }

  List<Object?> get props => [room, checkIn, checkOut, extraBedIncluded, breakfastIncluded, breakfastCount];
}

