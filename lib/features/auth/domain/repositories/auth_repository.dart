import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String login, String password);
  Future<void> logout();
  Future<UserEntity?> getAuthenticatedUser();

  Future<UserEntity> registerParticulier({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String sexe,
    required String pays,
    required String adresse,
  });

  Future<UserEntity> registerCompany({
    required String email,
    required String password,
    required String companyName,
    required String telephone,
    required String pays,
    required String adresse,
    required bool isExterne,
  });
}

