import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';
import 'package:sra_hotel/features/user_management/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);

  Future<List<StaffUser>> call() async {
    return await repository.getUsers();
  }
}
