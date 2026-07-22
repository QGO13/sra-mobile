import 'package:sra_hotel/features/checkout/domain/repositories/payment_repository.dart';

class InitiatePaymentUseCase {
  final PaymentRepository repository;

  InitiatePaymentUseCase({required this.repository});

  Future<Map<String, dynamic>> call({
    required double amount,
    required String phone,
    required String operator,
    required String email,
    required String clientName,
  }) async {
    return await repository.initiatePayment(
      amount: amount,
      phone: phone,
      operator: operator,
      email: email,
      clientName: clientName,
    );
  }
}

class VerifyPaymentStatusUseCase {
  final PaymentRepository repository;

  VerifyPaymentStatusUseCase({required this.repository});

  Future<bool> call(String transactionId) async {
    return await repository.verifyPaymentStatus(transactionId);
  }
}

