import 'package:sra_hotel/features/reception/domain/entities/arrival_departure.dart';
import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';

class GetArrivalsUseCase {
  final ReceptionRepository repository;
  GetArrivalsUseCase(this.repository);

  Future<List<ArrivalDeparture>> call() async {
    return await repository.getArrivals();
  }
}
