import 'package:sra_hotel/features/backoffice_kpis/domain/entities/kpi_data.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/repositories/kpi_repository.dart';

class GetKpisUseCase {
  final KpiRepository repository;

  GetKpisUseCase(this.repository);

  Future<KpiData> call() async {
    return await repository.getKpis();
  }
}
