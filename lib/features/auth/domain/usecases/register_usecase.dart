import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';

class RegisterParticulierParams {
  final String email;
  final String password;
  final String nom;
  final String prenoms;
  final String telephone;
  final String sexe;
  final String pays;
  final String adresse;

  const RegisterParticulierParams({
    required this.email,
    required this.password,
    required this.nom,
    required this.prenoms,
    required this.telephone,
    required this.sexe,
    required this.pays,
    required this.adresse,
  });
}

class RegisterCompanyParams {
  final String email;
  final String password;
  final String companyName;
  final String telephone;
  final String pays;
  final String adresse;
  final bool isExterne;

  const RegisterCompanyParams({
    required this.email,
    required this.password,
    required this.companyName,
    required this.telephone,
    required this.pays,
    required this.adresse,
    required this.isExterne,
  });
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> registerParticulier(RegisterParticulierParams params) async {
    return await repository.registerParticulier(
      email: params.email,
      password: params.password,
      nom: params.nom,
      prenoms: params.prenoms,
      telephone: params.telephone,
      sexe: params.sexe,
      pays: params.pays,
      adresse: params.adresse,
    );
  }

  Future<UserEntity> registerCompany(RegisterCompanyParams params) async {
    return await repository.registerCompany(
      email: params.email,
      password: params.password,
      companyName: params.companyName,
      telephone: params.telephone,
      pays: params.pays,
      adresse: params.adresse,
      isExterne: params.isExterne,
    );
  }
}

