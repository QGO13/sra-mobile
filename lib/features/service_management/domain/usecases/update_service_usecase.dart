import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';
import 'package:sra_hotel/features/service_management/domain/repositories/service_repository.dart';

class UpdateServiceUseCase {
  final ServiceRepository repository;
  UpdateServiceUseCase(this.repository);

  Future<HotelService> call(HotelService service) async {
    return await repository.updateService(service);
  }
}
