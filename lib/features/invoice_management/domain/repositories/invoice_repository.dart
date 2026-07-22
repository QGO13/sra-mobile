import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';

abstract class InvoiceRepository {
  Future<List<ClientInvoice>> getInvoices();
}
