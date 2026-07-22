import 'package:sra_hotel/features/invoice_management/data/datasources/invoice_remote_data_source.dart';
import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';
import 'package:sra_hotel/features/invoice_management/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ClientInvoice>> getInvoices() async {
    return await remoteDataSource.getInvoices();
  }
}
