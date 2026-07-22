import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';
import 'package:sra_hotel/features/service_management/domain/repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository repository;
  GetServicesUseCase(this.repository);

  Future<List<HotelService>> call() async {
    return await repository.getServices();
  }
}
