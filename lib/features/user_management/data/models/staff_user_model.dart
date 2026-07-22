import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';

class StaffUserModel extends StaffUser {
  StaffUserModel({
    required super.id,
    required super.login,
    required super.role,
    required super.nom,
    required super.prenoms,
    required super.telephone,
    required super.sexe,
    required super.pays,
    required super.adresse,
    required super.isActive,
  });

  factory StaffUserModel.fromJson(Map<String, dynamic> json) {
    final nestedUser = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final email = (json['email'] ?? json['login'] ?? nestedUser['email'] ?? '').toString();
    final firstName = (nestedUser['first_name'] ?? json['prenoms'] ?? json['first_name'] ?? '').toString();
    final lastName = (nestedUser['last_name'] ?? json['nom'] ?? json['last_name'] ?? '').toString();
    final phone = (nestedUser['phone'] ?? json['telephone'] ?? '').toString();
    final gender = (nestedUser['gender'] ?? json['sexe'] ?? '').toString();
    final country = (nestedUser['country'] ?? json['pays'] ?? '').toString();
    final address = (nestedUser['address'] ?? json['adresse'] ?? '').toString();

    return StaffUserModel(
      id: (json['id'] ?? '').toString(),
      login: email,
      role: (json['role'] ?? 'reception').toString(),
      nom: lastName,
      prenoms: firstName,
      telephone: phone,
      sexe: gender,
      pays: country,
      adresse: address,
      isActive: json['is_active'] is bool ? ((json['is_active'] as bool) ? 1 : 0) : (json['is_active'] as int? ?? 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': login,
      'login': login,
      'role': role,
      'nom': nom,
      'prenoms': prenoms,
      'telephone': telephone,
      'sexe': sexe,
      'pays': pays,
      'adresse': adresse,
      'is_active': isActive,
      'user_id': id,
    };
  }

  StaffUserModel copyWith({
    String? id,
    String? login,
    String? role,
    String? nom,
    String? prenoms,
    String? telephone,
    String? sexe,
    String? pays,
    String? adresse,
    int? isActive,
  }) {
    return StaffUserModel(
      id: id ?? this.id,
      login: login ?? this.login,
      role: role ?? this.role,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      telephone: telephone ?? this.telephone,
      sexe: sexe ?? this.sexe,
      pays: pays ?? this.pays,
      adresse: adresse ?? this.adresse,
      isActive: isActive ?? this.isActive,
    );
  }
}
