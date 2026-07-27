import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';
import 'package:sra_hotel/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository implements AuthRepository {
  final UserEntity? mockUser;
  final bool shouldThrow;

  MockAuthRepository({this.mockUser, this.shouldThrow = false});

  @override
  Future<UserEntity> login(String login, String password) async {
    if (shouldThrow) {
      throw Exception('Identifiants invalides');
    }
    return mockUser ?? const UserEntity(id: '1', login: 'test@srah.com', role: 'CLIENT');
  }

  @override
  Future<UserEntity?> getAuthenticatedUser() async => mockUser;

  @override
  Future<void> logout() async {}

  @override
  Future<UserEntity> registerParticulier({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String sexe,
    required String pays,
    required String adresse,
  }) async {
    return mockUser ?? UserEntity(id: '1', login: email, role: 'CLIENT');
  }

  @override
  Future<UserEntity> registerCompany({
    required String email,
    required String password,
    required String companyName,
    required String telephone,
    required String pays,
    required String adresse,
    required bool isExterne,
  }) async {
    return mockUser ?? UserEntity(id: '1', login: email, role: 'CLIENT');
  }
}

void main() {
  group('LoginUseCase Tests', () {
    test('devrait retourner UserEntity lorsque les identifiants sont valides', () async {
      const mockUser = UserEntity(id: '100', login: 'admin@srah.com', role: 'ADMIN');
      final repository = MockAuthRepository(mockUser: mockUser);
      final useCase = LoginUseCase(repository);

      final result = await useCase(const LoginParams(login: 'admin@srah.com', password: 'password123'));

      expect(result.id, '100');
      expect(result.login, 'admin@srah.com');
      expect(result.role, 'ADMIN');
    });

    test('devrait lever une exception en cas d\'erreur d\'authentification', () async {
      final repository = MockAuthRepository(shouldThrow: true);
      final useCase = LoginUseCase(repository);

      expect(
        () => useCase(const LoginParams(login: 'wrong@srah.com', password: 'bad')),
        throwsA(isA<Exception>()),
      );
    });
  });
}
