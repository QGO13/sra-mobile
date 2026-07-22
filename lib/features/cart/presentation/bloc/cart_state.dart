import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartState {
  const CartState();

  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItemEntity> items;
  final DateTime checkIn;
  final DateTime checkOut;

  const CartUpdated({
    required this.items,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  List<Object?> get props => [items, checkIn, checkOut];
  
  // Calculate stay duration in nights
  int get nights {
    final diff = checkOut.difference(checkIn).inDays;
    return diff > 0 ? diff : 1; // Safeguard: minimum 1 night
  }
  
  // Calculate cumulative stay total HT (sum of item totals which already include their own nights count)
  double get cartSubtotal => items.fold(0.0, (sum, item) => sum + item.itemTotal);
}

