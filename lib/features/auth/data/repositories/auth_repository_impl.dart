import 'package:sra_hotel/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sra_hotel/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String login, String password) async {
    try {
      final (user, token) = await remoteDataSource.login(login, password);
      await localDataSource.saveSession(user, token);
      return user;
    } catch (e) {
      // If offline, check if we can login with cached session or throw
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null && cachedUser.login == login) {
        return cachedUser;
      }
      rethrow;
    }
  }

  @override
  Future<UserEntity> registerParticulier({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String sexe,
    required String pays,
    required String adresse,
  }) async {
    final (user, token) = await remoteDataSource.registerParticulier(
      email: email,
      password: password,
      nom: nom,
      prenoms: prenoms,
      telephone: telephone,
      sexe: sexe,
      pays: pays,
      adresse: adresse,
    );
    await localDataSource.saveSession(user, token);
    return user;
  }

  @override
  Future<UserEntity> registerCompany({
    required String email,
    required String password,
    required String companyName,
    required String telephone,
    required String pays,
    required String adresse,
    required bool isExterne,
  }) async {
    final (user, token) = await remoteDataSource.registerCompany(
      email: email,
      password: password,
      companyName: companyName,
      telephone: telephone,
      pays: pays,
      adresse: adresse,
      isExterne: isExterne,
    );
    await localDataSource.saveSession(user, token);
    return user;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearSession();
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async {
    return await localDataSource.getCachedUser();
  }
}

