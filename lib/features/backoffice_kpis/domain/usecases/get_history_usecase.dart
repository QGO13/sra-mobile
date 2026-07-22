import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/repositories/kpi_repository.dart';

class GetHistoryUseCase {
  final KpiRepository repository;

  GetHistoryUseCase(this.repository);

  Future<HistoryData> call() async {
    return await repository.getHistory();
  }
}
