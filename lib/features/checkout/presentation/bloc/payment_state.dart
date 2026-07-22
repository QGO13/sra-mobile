abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {
  final String message;

  const PaymentLoading({this.message = "Traitement du paiement..."});
}

class PaymentRedirectRequired extends PaymentState {
  final String transactionId;
  final String checkoutUrl;

  const PaymentRedirectRequired({
    required this.transactionId,
    required this.checkoutUrl,
  });
}

class PaymentSuccess extends PaymentState {
  final String transactionId;

  const PaymentSuccess({required this.transactionId});
}

class PaymentFailure extends PaymentState {
  final String errorMessage;

  const PaymentFailure({required this.errorMessage});
}

