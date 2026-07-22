import 'package:sra_hotel/features/service_management/domain/repositories/service_repository.dart';

class DeleteServiceUseCase {
  final ServiceRepository repository;
  DeleteServiceUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteService(id);
  }
}
