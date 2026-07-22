import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.login,
    required super.role,
    super.nom,
    super.prenoms,
    super.telephone,
    super.sexe,
    super.pays,
    super.adresse,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>?;
    
    return UserModel(
      id: userMap != null && userMap['id'] != null 
          ? userMap['id'].toString() 
          : (json['id_user'] ?? json['id'] ?? '').toString(),
      login: (json['email'] ?? json['login'] ?? (userMap != null ? userMap['email'] : '')) as String,
      role: (json['role'] ?? 'client') as String,
      nom: userMap != null ? userMap['last_name'] as String? : json['nom'] as String?,
      prenoms: userMap != null ? userMap['first_name'] as String? : json['prenoms'] as String?,
      telephone: userMap != null ? userMap['phone'] as String? : json['telephone'] as String?,
      sexe: userMap != null ? userMap['gender'] as String? : json['sexe'] as String?,
      pays: userMap != null ? userMap['country'] as String? : json['pays'] as String?,
      adresse: userMap != null ? userMap['address'] as String? : json['adresse'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'role': role,
      'nom': nom,
      'prenoms': prenoms,
      'telephone': telephone,
      'sexe': sexe,
      'pays': pays,
      'adresse': adresse,
    };
  }
}

