class StaffUser {
  final String id;
  final String login;
  final String role;
  final String nom;
  final String prenoms;
  final String telephone;
  final String sexe;
  final String pays;
  final String adresse;
  final int isActive;

  StaffUser({
    required this.id,
    required this.login,
    required this.role,
    required this.nom,
    required this.prenoms,
    required this.telephone,
    required this.sexe,
    required this.pays,
    required this.adresse,
    required this.isActive,
  });
}
