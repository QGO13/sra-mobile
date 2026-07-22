import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/invoice_management/domain/usecases/get_invoices_usecase.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoicesUseCase getInvoicesUseCase;

  InvoiceBloc({required this.getInvoicesUseCase}) : super(InvoiceInitial()) {
    on<LoadInvoicesEvent>(_onLoadInvoices);
  }

  Future<void> _onLoadInvoices(LoadInvoicesEvent event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      final list = await getInvoicesUseCase();
      emit(InvoiceLoaded(list));
    } catch (e) {
      emit(InvoiceFailure(e.toString()));
    }
  }
}
