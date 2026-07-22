import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/usecases/get_kpis_usecase.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/usecases/get_history_usecase.dart';
import 'kpi_event.dart';
import 'kpi_state.dart';

class KpiBloc extends Bloc<KpiEvent, KpiState> {
  final GetKpisUseCase getKpisUseCase;
  final GetHistoryUseCase getHistoryUseCase;

  KpiBloc({
    required this.getKpisUseCase,
    required this.getHistoryUseCase,
  }) : super(KpiInitial()) {
    on<LoadKpiDashboardEvent>(_onLoadKpiDashboard);
  }

  Future<void> _onLoadKpiDashboard(
    LoadKpiDashboardEvent event,
    Emitter<KpiState> emit,
  ) async {
    emit(KpiLoading());
    try {
      final results = await Future.wait([
        getKpisUseCase(),
        getHistoryUseCase(),
      ]);

      emit(KpiLoaded(
        kpi: results[0] as KpiData,
        history: results[1] as HistoryData,
      ));
    } catch (e) {
      emit(KpiFailure(e.toString()));
    }
  }
}
