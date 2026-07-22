import 'package:dio/dio.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel user, String token)> login(String login, String password);
  
  Future<(UserModel user, String token)> registerParticulier({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String sexe,
    required String pays,
    required String adresse,
  });

  Future<(UserModel user, String token)> registerCompany({
    required String email,
    required String password,
    required String companyName,
    required String telephone,
    required String pays,
    required String adresse,
    required bool isExterne,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<(UserModel user, String token)> login(String login, String password) async {
    try {
      // 1. Appeler /token au format x-www-form-urlencoded
      final response = await apiClient.dio.post(
        '/token',
        data: {
          'username': login,
          'password': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['access_token'] as String;

        // 2. Récupérer le compte courant /accounts/me avec le token d'accès
        final meResponse = await apiClient.dio.get(
          '/accounts/me',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (meResponse.statusCode == 200) {
          final accountData = meResponse.data as Map<String, dynamic>;
          final user = UserModel.fromJson(accountData);
          return (user, token);
        } else {
          throw Exception('Erreur de profil : ${meResponse.statusMessage}');
        }
      } else {
        throw Exception('Erreur de connexion : ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<(UserModel user, String token)> registerParticulier({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String sexe,
    required String pays,
    required String adresse,
  }) async {
    try {
      // 1. Appeler /signup pour créer le compte
      final response = await apiClient.dio.post(
        '/signup',
        data: {
          'first_name': prenoms,
          'last_name': nom,
          'phone': telephone,
          'email': email,
          'address': adresse,
          'gender': sexe,
          'country': pays,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 2. Une fois créé, faire le login pour récupérer le token et l'utilisateur
        return await login(email, password);
      } else {
        throw Exception('Erreur d\'inscription : ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  @override
  Future<(UserModel user, String token)> registerCompany({
    required String email,
    required String password,
    required String companyName,
    required String telephone,
    required String pays,
    required String adresse,
    required bool isExterne,
  }) async {
    throw UnimplementedError('L\'inscription d\'entreprise n\'est pas prise en charge pour le moment.');
  }

  String _extractErrorMessage(DioException e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('detail')) {
          final detail = data['detail'];
          if (detail is String) {
            return detail;
          } else if (detail is List) {
            // Cas des erreurs de validation de formulaire de FastAPI (422)
            final messages = detail.map((err) {
              if (err is Map<String, dynamic>) {
                final loc = err['loc'] as List?;
                final msg = err['msg'] as String?;
                final field = loc != null && loc.length > 1 ? loc[1] : '';
                if (field.isNotEmpty) {
                  return 'Champ "$field" : $msg';
                }
                return msg ?? 'Erreur de validation';
              }
              return err.toString();
            }).join('\n');
            return 'Erreurs de validation :\n$messages';
          }
        }
      }
    }
    
    // Si on a un code de statut mais pas de corps structuré
    if (e.response != null) {
      if (e.response!.statusCode == 422) {
        return 'Erreur 422 : Données invalides ou mal formées.';
      }
      return 'Erreur ${e.response!.statusCode} : ${e.response!.statusMessage ?? "Erreur serveur"}';
    }

    return e.message ?? 'Une erreur réseau est survenue.';
  }
}

