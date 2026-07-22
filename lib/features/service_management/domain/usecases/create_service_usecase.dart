import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';
import 'package:sra_hotel/features/service_management/domain/repositories/service_repository.dart';

class CreateServiceUseCase {
  final ServiceRepository repository;
  CreateServiceUseCase(this.repository);

  Future<HotelService> call(HotelService service) async {
    return await repository.createService(service);
  }
}
