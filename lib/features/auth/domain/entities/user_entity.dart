class UserEntity {
  final String id;
  final String login;
  final String role;
  // Profile fields inherited from Personne
  final String? nom;
  final String? prenoms;
  final String? telephone;
  final String? sexe;
  final String? pays;
  final String? adresse;

  const UserEntity({
    required this.id,
    required this.login,
    required this.role,
    this.nom,
    this.prenoms,
    this.telephone,
    this.sexe,
    this.pays,
    this.adresse,
  });

  List<Object?> get props => [id, login, role, nom, prenoms, telephone, sexe, pays, adresse];
}

