import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';

abstract class ServiceRepository {
  Future<List<HotelService>> getServices();
  Future<HotelService> createService(HotelService service);
  Future<HotelService> updateService(HotelService service);
  Future<void> deleteService(int id);
}
