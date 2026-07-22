abstract class PaymentEvent {
  const PaymentEvent();
}

class StartMomoPayment extends PaymentEvent {
  final double amount;
  final String phone;
  final String operator;
  final String email;
  final String clientName;

  const StartMomoPayment({
    required this.amount,
    required this.phone,
    required this.operator,
    required this.email,
    required this.clientName,
  });
}

class StartCardPayment extends PaymentEvent {
  final double amount;
  final String email;
  final String clientName;

  const StartCardPayment({
    required this.amount,
    required this.email,
    required this.clientName,
  });
}

class CheckPaymentStatus extends PaymentEvent {
  final String transactionId;

  const CheckPaymentStatus({required this.transactionId});
}

class ResetPaymentState extends PaymentEvent {}

