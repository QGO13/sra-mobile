import 'dart:convert';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';
import 'package:sra_hotel/features/user_management/data/models/staff_user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<StaffUserModel>> getUsers();
  Future<StaffUserModel> createUser(StaffUserModel user);
  Future<StaffUserModel> updateUser(StaffUserModel user);
  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;
  final ApiCache apiCache;

  UserRemoteDataSourceImpl({required this.apiClient, required this.apiCache});

  @override
  Future<List<StaffUserModel>> getUsers() async {
    try {
      final response = await apiClient.get('/accounts/', queryParameters: {'limit': 100});
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        await apiCache.save('users', jsonEncode(response.data));
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List<dynamic>? ?? const [];
        return data.map((json) => StaffUserModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return const <StaffUserModel>[];
    } catch (e) {
      final cachedStr = await apiCache.get('users');
      if (cachedStr != null) {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        final data = decoded['data'] as List<dynamic>? ?? const [];
        return data.map((json) => StaffUserModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  @override
  Future<StaffUserModel> createUser(StaffUserModel user) async {
    // 1. Create account + user via signup
    final signupResponse = await apiClient.post(
      '/signup',
      data: {
        'first_name': user.prenoms,
        'last_name': user.nom,
        'phone': user.telephone,
        'email': user.login,
        'address': user.adresse,
        'gender': user.sexe,
        'country': user.pays,
        'password': 'DefaultPassword123!', // default password for new staff
      },
    );
    
    if (signupResponse.statusCode == 200 || signupResponse.statusCode == 201) {
      final accountData = signupResponse.data as Map<String, dynamic>;
      final createdAccount = StaffUserModel.fromJson(accountData);
      
      // 2. If role is not client, promote/update the role
      if (user.role != 'client') {
        final updateResponse = await apiClient.dio.patch(
          '/accounts/${createdAccount.id}',
          data: {
            'role': user.role,
          },
        );
        if (updateResponse.statusCode == 200) {
          return StaffUserModel.fromJson(updateResponse.data as Map<String, dynamic>);
        }
      }
      return createdAccount;
    } else {
      throw Exception('Erreur de création du compte: ${signupResponse.statusMessage}');
    }
  }

  @override
  Future<StaffUserModel> updateUser(StaffUserModel user) async {
    // 1. Fetch current account to retrieve the user_id
    final getResponse = await apiClient.get('/accounts/${user.id}');
    if (getResponse.statusCode == 200) {
      final accountData = getResponse.data as Map<String, dynamic>;
      final userId = accountData['user_id'] as int;
      
      // 2. Update user profile details
      await apiClient.dio.patch(
        '/users/$userId',
        data: {
          'first_name': user.prenoms,
          'last_name': user.nom,
          'phone': user.telephone,
          'address': user.adresse,
          'gender': user.sexe,
          'country': user.pays,
        },
      );
      
      // 3. Update account details (role, email, isActive)
      final updateResponse = await apiClient.dio.patch(
        '/accounts/${user.id}',
        data: {
          'email': user.login,
          'role': user.role,
          'is_active': user.isActive == 1,
        },
      );
      
      if (updateResponse.statusCode == 200) {
        return StaffUserModel.fromJson(updateResponse.data as Map<String, dynamic>);
      }
    }
    throw Exception('Erreur de mise à jour de l\'utilisateur');
  }

  @override
  Future<void> deleteUser(int id) async {
    await apiClient.delete('/accounts/$id');
  }
}
