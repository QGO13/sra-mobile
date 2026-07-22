abstract class PaymentRepository {
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String phone,
    required String operator, // mtn, moov, orange, wave, card
    required String email,
    required String clientName,
  });

  Future<bool> verifyPaymentStatus(String transactionId);
}

