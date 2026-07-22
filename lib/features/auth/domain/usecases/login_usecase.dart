import 'package:sra_hotel/core/usecases/usecase.dart';
import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String login;
  final String password;

  const LoginParams({required this.login, required this.password});
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<UserEntity> call(LoginParams params) async {
    return await repository.login(params.login, params.password);
  }
}

