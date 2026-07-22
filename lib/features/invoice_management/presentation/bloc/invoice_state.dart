import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<ClientInvoice> invoices;
  InvoiceLoaded(this.invoices);
}

class InvoiceFailure extends InvoiceState {
  final String error;
  InvoiceFailure(this.error);
}
