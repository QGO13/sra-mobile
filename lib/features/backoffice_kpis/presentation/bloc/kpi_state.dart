import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';

abstract class KpiState {}

class KpiInitial extends KpiState {}

class KpiLoading extends KpiState {}

class KpiLoaded extends KpiState {
  final KpiData kpi;
  final HistoryData history;

  KpiLoaded({required this.kpi, required this.history});
}

class KpiFailure extends KpiState {
  final String error;
  KpiFailure(this.error);
}
