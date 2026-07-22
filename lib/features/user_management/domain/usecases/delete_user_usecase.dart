import 'package:sra_hotel/features/user_management/domain/repositories/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository repository;
  DeleteUserUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteUser(id);
  }
}
