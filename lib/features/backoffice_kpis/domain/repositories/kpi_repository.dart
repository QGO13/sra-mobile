import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';

abstract class KpiRepository {
  Future<KpiData> getKpis();
  Future<HistoryData> getHistory();
}
