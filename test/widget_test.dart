import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sra_hotel/main.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';
import 'package:sra_hotel/features/auth/domain/usecases/login_usecase.dart';
import 'package:sra_hotel/features/auth/domain/usecases/register_usecase.dart';
import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> getAuthenticatedUser() async => null;

  @override
  Future<UserEntity> login(String login, String password) async {
    return const UserEntity(
      id: '123',
      login: 'test@sra-hotel.com',
      role: 'client',
    );
  }

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
    return UserEntity(
      id: '123',
      login: email,
      role: 'client',
      nom: nom,
      prenoms: prenoms,
      telephone: telephone,
      sexe: sexe,
      pays: pays,
      adresse: adresse,
    );
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
    return UserEntity(
      id: '123',
      login: email,
      role: 'client',
      nom: companyName,
      prenoms: isExterne ? 'Agence' : 'Corporate',
      telephone: telephone,
      sexe: 'N/A',
      pays: pays,
      adresse: adresse,
    );
  }
}

void main() {
  setUp(() async {
    final sl = GetIt.instance;
    await sl.reset();
    
    final mockRepo = MockAuthRepository();
    sl.registerLazySingleton<AuthRepository>(() => mockRepo);
    sl.registerLazySingleton(() => LoginUseCase(mockRepo));
    sl.registerLazySingleton(() => RegisterUseCase(mockRepo));
    sl.registerFactory(() => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      authRepository: sl(),
    ));
  });

  testWidgets('Welcome page smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pump(); // Affiche la page de bienvenue initiale

    // Vérifie que le slogan est présent
    expect(find.text('"Make yourself at home"'), findsOneWidget);

    await tester.pumpAndSettle(); // Attend la redirection automatique vers la page de connexion
    
    // Vérifie que le bouton de connexion est présent sur la page de connexion
    expect(find.text('CONTINUER →'), findsOneWidget);
  });
}
