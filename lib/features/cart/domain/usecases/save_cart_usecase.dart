import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sra_hotel/features/cart/domain/repositories/cart_repository.dart';

class SaveCartUseCase {
  final ICartRepository repository;

  SaveCartUseCase(this.repository);

  Future<void> call({
    required List<CartItemEntity> items,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    await repository.saveCart(items: items, checkIn: checkIn, checkOut: checkOut);
  }
}
