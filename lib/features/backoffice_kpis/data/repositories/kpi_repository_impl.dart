import 'package:sra_hotel/features/backoffice_kpis/data/datasources/kpi_remote_data_source.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/entities/history_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/repositories/kpi_repository.dart';

class KpiRepositoryImpl implements KpiRepository {
  final KpiRemoteDataSource remoteDataSource;

  KpiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<KpiData> getKpis() async {
    return await remoteDataSource.getKpis();
  }

  @override
  Future<HistoryData> getHistory() async {
    return await remoteDataSource.getHistory();
  }
}
