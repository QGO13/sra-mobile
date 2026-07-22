import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';
import 'package:sra_hotel/features/user_management/domain/repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;
  UpdateUserUseCase(this.repository);

  Future<StaffUser> call(StaffUser user) async {
    return await repository.updateUser(user);
  }
}
