import 'package:sra_hotel/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  final ICartRepository repository;

  ClearCartUseCase(this.repository);

  Future<void> call() async {
    await repository.clearCart();
  }
}
