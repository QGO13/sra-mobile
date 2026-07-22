import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';

class PerformCheckOutUseCase {
  final ReceptionRepository repository;
  PerformCheckOutUseCase(this.repository);

  Future<void> call(String ref) async {
    return await repository.performCheckOut(ref);
  }
}
