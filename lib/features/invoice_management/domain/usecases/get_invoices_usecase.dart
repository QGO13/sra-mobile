import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';
import 'package:sra_hotel/features/invoice_management/domain/repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository repository;
  GetInvoicesUseCase(this.repository);

  Future<List<ClientInvoice>> call() async {
    return await repository.getInvoices();
  }
}
