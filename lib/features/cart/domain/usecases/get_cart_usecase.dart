import 'package:sra_hotel/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase {
  final ICartRepository repository;

  GetCartUseCase(this.repository);

  Future<Map<String, dynamic>?> call() async {
    return await repository.getCart();
  }
}
