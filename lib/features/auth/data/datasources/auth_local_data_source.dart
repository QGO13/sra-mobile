import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sra_hotel/core/database/local_database.dart';
import 'package:sra_hotel/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(UserModel user, String token);
  Future<void> clearSession();
  Future<UserModel?> getCachedUser();
  Future<String?> getCachedToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final LocalDatabase localDatabase;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.localDatabase,
  });

  @override
  Future<void> saveSession(UserModel user, String token) async {
    await secureStorage.write(key: 'access_token', value: token);
    await secureStorage.write(key: 'cached_user', value: jsonEncode(user.toJson()));
    
    if (kIsWeb) return;
    
    // Cache the user in SQflite tables
    final db = await localDatabase.database;
    if (db == null) return;
    await db.transaction((txn) async {
      await txn.insert(
        'personne',
        {
          'id_personne': user.id,
          'nom': user.nom,
          'prenoms': user.prenoms,
          'telephone': user.telephone,
          'email': user.login, // We map the login/email to the personne email field
          'sexe': user.sexe,
          'pays': user.pays,
          'adresse': user.adresse,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.insert(
        'users',
        {
          'id_user': user.id,
          'login': user.login,
          'is_active': 1,
          'role': user.role,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // If it is a Corporate or Agence account, cache in Company & Employer tables
      if (user.prenoms == 'Corporate' || user.prenoms == 'Agence') {
        final isAgence = user.prenoms == 'Agence' ? 1 : 0;
        await txn.insert(
          'company',
          {
            'id_company': user.id,
            'login_comp': user.login,
            'password_comp': 'cached_password_placeholder',
            'is_externe': isAgence,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await txn.insert(
          'employer',
          {
            'id_company': user.id,
            'id_personne': user.id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> clearSession() async {
    await secureStorage.delete(key: 'access_token');
    await secureStorage.delete(key: 'cached_user');
    if (kIsWeb) return;
    try {
      final db = await localDatabase.database;
      if (db != null) {
        await db.delete('api_cache').catchError((_) => 0);
        await db.delete('reservations').catchError((_) => 0);
        await db.delete('chambres').catchError((_) => 0);
        await db.delete('personne').catchError((_) => 0);
        await db.delete('users').catchError((_) => 0);
        await db.delete('company').catchError((_) => 0);
        await db.delete('employer').catchError((_) => 0);
      }
    } catch (_) {
      // Ignorer silencieusement
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final cachedString = await secureStorage.read(key: 'cached_user');
    if (cachedString != null) {
      return UserModel.fromJson(jsonDecode(cachedString) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<String?> getCachedToken() async {
    return await secureStorage.read(key: 'access_token');
  }
}

