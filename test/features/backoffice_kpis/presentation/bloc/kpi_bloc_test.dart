import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/repositories/kpi_repository.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/usecases/get_history_usecase.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/usecases/get_kpis_usecase.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_bloc.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_event.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_state.dart';

class MockKpiRepository implements KpiRepository {
  final bool shouldThrow;

  MockKpiRepository({this.shouldThrow = false});

  @override
  Future<KpiData> getKpis() async {
    if (shouldThrow) throw Exception('Erreur de chargement KPI');
    return KpiData(
      caMensuel: 15000000,
      caDelta: '+12%',
      tauxOccupation: 85,
      tauxDelta: '+5%',
      revpar: 45000,
      revparDelta: '+8%',
      panierMoyen: 60000,
      panierDelta: '-2%',
    );
  }

  @override
  Future<HistoryData> getHistory() async {
    if (shouldThrow) throw Exception('Erreur de chargement Historique');
    return HistoryData(
      labels: ['Jan', 'Fév', 'Mar'],
      revenue: [10.0, 12.0, 15.0],
      occupancy: [70.0, 75.0, 85.0],
    );
  }
}

void main() {
  group('KpiBloc Tests', () {
    late MockKpiRepository repository;
    late GetKpisUseCase getKpisUseCase;
    late GetHistoryUseCase getHistoryUseCase;
    late KpiBloc kpiBloc;

    setUp(() {
      repository = MockKpiRepository();
      getKpisUseCase = GetKpisUseCase(repository);
      getHistoryUseCase = GetHistoryUseCase(repository);
      kpiBloc = KpiBloc(
        getKpisUseCase: getKpisUseCase,
        getHistoryUseCase: getHistoryUseCase,
      );
    });

    tearDown(() {
      kpiBloc.close();
    });

    test('L\'état initial doit être KpiInitial', () {
      expect(kpiBloc.state, isA<KpiInitial>());
    });

    test('Doit émettre [KpiLoading, KpiLoaded] lors du chargement des KPIs', () async {
      final expectedStates = [
        isA<KpiLoading>(),
        isA<KpiLoaded>(),
      ];

      expectLater(kpiBloc.stream, emitsInOrder(expectedStates));

      kpiBloc.add(LoadKpiDashboardEvent());
    });

    test('Doit émettre [KpiLoading, KpiFailure] en cas d\'erreur de chargement', () async {
      final failingRepo = MockKpiRepository(shouldThrow: true);
      final failingBloc = KpiBloc(
        getKpisUseCase: GetKpisUseCase(failingRepo),
        getHistoryUseCase: GetHistoryUseCase(failingRepo),
      );

      final expectedStates = [
        isA<KpiLoading>(),
        isA<KpiFailure>(),
      ];

      expectLater(failingBloc.stream, emitsInOrder(expectedStates));

      failingBloc.add(LoadKpiDashboardEvent());
    });
  });
}
