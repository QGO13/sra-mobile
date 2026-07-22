import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/checkout/domain/usecases/payment_usecases.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_event.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final VerifyPaymentStatusUseCase verifyPaymentStatusUseCase;

  PaymentBloc({
    required this.initiatePaymentUseCase,
    required this.verifyPaymentStatusUseCase,
  }) : super(PaymentInitial()) {
    on<StartMomoPayment>(_onStartMomoPayment);
    on<StartCardPayment>(_onStartCardPayment);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<ResetPaymentState>(_onResetPaymentState);
  }

  Future<void> _onStartMomoPayment(
    StartMomoPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: "Déclenchement du push Mobile Money..."));
    try {
      final result = await initiatePaymentUseCase(
        amount: event.amount,
        phone: event.phone,
        operator: event.operator,
        email: event.email,
        clientName: event.clientName,
      );

      final status = result['status']?.toString().toLowerCase();
      final transactionId = result['transaction_id']?.toString() ?? '';

      if (status == 'failed') {
        emit(PaymentFailure(errorMessage: result['message']?.toString() ?? "Paiement Mobile Money échoué."));
      } else if (status == 'approved' || status == 'success') {
        emit(PaymentSuccess(transactionId: transactionId));
      } else {
        emit(const PaymentLoading(message: "Push envoyé. En attente de votre code PIN..."));
        
        // Simulating polling status check on Mobile Money transaction verification
        bool isApproved = false;
        for (int i = 0; i < 5; i++) {
          await Future.delayed(const Duration(seconds: 1500 ~/ 1000)); // Delays simulation matching backend processes
          isApproved = await verifyPaymentStatusUseCase(transactionId);
          if (isApproved) {
            break;
          }
        }

        if (isApproved) {
          emit(PaymentSuccess(transactionId: transactionId));
        } else {
          emit(const PaymentFailure(errorMessage: "Délai d'attente dépassé ou transaction annulée."));
        }
      }
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onStartCardPayment(
    StartCardPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: "Création de la session sécurisée..."));
    try {
      final result = await initiatePaymentUseCase(
        amount: event.amount,
        phone: "",
        operator: "card",
        email: event.email,
        clientName: event.clientName,
      );

      final checkoutUrl = result['checkout_url']?.toString() ?? '';
      final transactionId = result['transaction_id']?.toString() ?? '';

      if (checkoutUrl.isNotEmpty) {
        emit(PaymentRedirectRequired(
          transactionId: transactionId,
          checkoutUrl: checkoutUrl,
        ));
      } else {
        emit(const PaymentFailure(errorMessage: "Impossible d'initier la redirection carte."));
      }
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatus event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: "Vérification du statut de la transaction..."));
    try {
      final isApproved = await verifyPaymentStatusUseCase(event.transactionId);
      if (isApproved) {
        emit(PaymentSuccess(transactionId: event.transactionId));
      } else {
        emit(const PaymentFailure(errorMessage: "Le paiement n'a pas encore été finalisé ou a été refusé."));
      }
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }

  void _onResetPaymentState(
    ResetPaymentState event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentInitial());
  }
}

