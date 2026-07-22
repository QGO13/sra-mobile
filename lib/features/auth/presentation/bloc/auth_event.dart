abstract class AuthEvent {
  const AuthEvent();

  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String login;
  final String password;

  const LoginSubmitted({required this.login, required this.password});

  @override
  List<Object?> get props => [login, password];
}

class LogoutRequested extends AuthEvent {}

class RegisterParticulierSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String nom;
  final String prenoms;
  final String telephone;
  final String sexe;
  final String pays;
  final String adresse;

  const RegisterParticulierSubmitted({
    required this.email,
    required this.password,
    required this.nom,
    required this.prenoms,
    required this.telephone,
    required this.sexe,
    required this.pays,
    required this.adresse,
  });

  @override
  List<Object?> get props => [email, password, nom, prenoms, telephone, sexe, pays, adresse];
}

class RegisterCompanySubmitted extends AuthEvent {
  final String email;
  final String password;
  final String companyName;
  final String telephone;
  final String pays;
  final String adresse;
  final bool isExterne;

  const RegisterCompanySubmitted({
    required this.email,
    required this.password,
    required this.companyName,
    required this.telephone,
    required this.pays,
    required this.adresse,
    required this.isExterne,
  });

  @override
  List<Object?> get props => [email, password, companyName, telephone, pays, adresse, isExterne];
}


