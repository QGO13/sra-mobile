import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';

abstract class ICartRepository {
  Future<void> saveCart({
    required List<CartItemEntity> items,
    required DateTime checkIn,
    required DateTime checkOut,
  });
  Future<Map<String, dynamic>?> getCart();
  Future<void> clearCart();
}
