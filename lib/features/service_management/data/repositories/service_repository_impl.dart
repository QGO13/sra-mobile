import 'package:sra_hotel/features/service_management/data/datasources/service_remote_data_source.dart';
import 'package:sra_hotel/features/service_management/data/models/hotel_service_model.dart';
import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';
import 'package:sra_hotel/features/service_management/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HotelService>> getServices() async {
    return await remoteDataSource.getServices();
  }

  @override
  Future<HotelService> createService(HotelService service) async {
    return await remoteDataSource.createService(
      HotelServiceModel(
        id: service.id,
        nom: service.nom,
        prix: service.prix,
        categorie: service.categorie,
        description: service.description,
      ),
    );
  }

  @override
  Future<HotelService> updateService(HotelService service) async {
    return await remoteDataSource.updateService(
      HotelServiceModel(
        id: service.id,
        nom: service.nom,
        prix: service.prix,
        categorie: service.categorie,
        description: service.description,
      ),
    );
  }

  @override
  Future<void> deleteService(int id) async {
    await remoteDataSource.deleteService(id);
  }
}
