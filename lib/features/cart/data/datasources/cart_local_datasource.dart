import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sra_hotel/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<void> saveCart({
    required List<CartItemModel> items,
    required DateTime checkIn,
    required DateTime checkOut,
  });
  Future<Map<String, dynamic>?> getCart();
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String _itemsKey = 'cart_items';
  static const String _checkInKey = 'cart_check_in';
  static const String _checkOutKey = 'cart_check_out';

  CartLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveCart({
    required List<CartItemModel> items,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    final itemsJson = items.map((item) => item.toJson()).toList();
    await secureStorage.write(key: _itemsKey, value: jsonEncode(itemsJson));
    await secureStorage.write(key: _checkInKey, value: checkIn.toIso8601String());
    await secureStorage.write(key: _checkOutKey, value: checkOut.toIso8601String());
  }

  @override
  Future<Map<String, dynamic>?> getCart() async {
    final itemsStr = await secureStorage.read(key: _itemsKey);
    final checkInStr = await secureStorage.read(key: _checkInKey);
    final checkOutStr = await secureStorage.read(key: _checkOutKey);

    if (itemsStr == null || checkInStr == null || checkOutStr == null) {
      return null;
    }

    try {
      final List<dynamic> itemsJson = jsonDecode(itemsStr) as List<dynamic>;
      final items = itemsJson
          .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return {
        'items': items,
        'checkIn': DateTime.parse(checkInStr),
        'checkOut': DateTime.parse(checkOutStr),
      };
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCart() async {
    await secureStorage.delete(key: _itemsKey);
    await secureStorage.delete(key: _checkInKey);
    await secureStorage.delete(key: _checkOutKey);
  }
}
