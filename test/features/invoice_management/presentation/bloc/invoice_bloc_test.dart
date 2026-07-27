import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';
import 'package:sra_hotel/features/invoice_management/domain/repositories/invoice_repository.dart';
import 'package:sra_hotel/features/invoice_management/domain/usecases/get_invoices_usecase.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_bloc.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_event.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_state.dart';

class MockInvoiceRepository implements InvoiceRepository {
  final bool shouldThrow;

  MockInvoiceRepository({this.shouldThrow = false});

  @override
  Future<List<ClientInvoice>> getInvoices() async {
    if (shouldThrow) throw Exception('Erreur de chargement factures');
    return [
      ClientInvoice(
        id: '1',
        code: 'INV-2026-001',
        clientNom: 'Jean Dupont',
        prixTotal: 120000,
        dateCreation: '2026-07-24',
        statutFacture: 'PAYEE',
      ),
    ];
  }
}

void main() {
  group('InvoiceBloc Tests', () {
    late MockInvoiceRepository repository;
    late GetInvoicesUseCase getInvoicesUseCase;
    late InvoiceBloc invoiceBloc;

    setUp(() {
      repository = MockInvoiceRepository();
      getInvoicesUseCase = GetInvoicesUseCase(repository);
      invoiceBloc = InvoiceBloc(getInvoicesUseCase: getInvoicesUseCase);
    });

    tearDown(() {
      invoiceBloc.close();
    });

    test('L\'état initial doit être InvoiceInitial', () {
      expect(invoiceBloc.state, isA<InvoiceInitial>());
    });

    test('Doit émettre [InvoiceLoading, InvoiceLoaded] lors du chargement des factures', () async {
      final expectedStates = [
        isA<InvoiceLoading>(),
        isA<InvoiceLoaded>(),
      ];

      expectLater(invoiceBloc.stream, emitsInOrder(expectedStates));

      invoiceBloc.add(LoadInvoicesEvent());
    });

    test('Doit émettre [InvoiceLoading, InvoiceFailure] en cas d\'erreur de chargement', () async {
      final failingRepo = MockInvoiceRepository(shouldThrow: true);
      final failingBloc = InvoiceBloc(getInvoicesUseCase: GetInvoicesUseCase(failingRepo));

      final expectedStates = [
        isA<InvoiceLoading>(),
        isA<InvoiceFailure>(),
      ];

      expectLater(failingBloc.stream, emitsInOrder(expectedStates));

      failingBloc.add(LoadInvoicesEvent());
    });
  });
}
