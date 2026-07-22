import 'package:sra_hotel/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:sra_hotel/features/cart/data/models/cart_item_model.dart';
import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sra_hotel/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements ICartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveCart({
    required List<CartItemEntity> items,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    final modelItems = items.map((item) => CartItemModel(
      room: item.room,
      checkIn: item.checkIn,
      checkOut: item.checkOut,
      extraBedIncluded: item.extraBedIncluded,
      breakfastIncluded: item.breakfastIncluded,
      breakfastCount: item.breakfastCount,
    )).toList();
    await localDataSource.saveCart(items: modelItems, checkIn: checkIn, checkOut: checkOut);
  }

  @override
  Future<Map<String, dynamic>?> getCart() async {
    return await localDataSource.getCart();
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}
