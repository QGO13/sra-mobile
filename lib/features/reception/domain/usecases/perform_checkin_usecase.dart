import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';

class PerformCheckInUseCase {
  final ReceptionRepository repository;
  PerformCheckInUseCase(this.repository);

  Future<void> call(String ref, String roomNo) async {
    return await repository.performCheckIn(ref, roomNo);
  }
}
