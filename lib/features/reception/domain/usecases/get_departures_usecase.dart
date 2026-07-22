import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';

class GetDeparturesUseCase {
  final ReceptionRepository repository;
  GetDeparturesUseCase(this.repository);

  Future<List<ArrivalDeparture>> call() async {
    return await repository.getDepartures();
  }
}
