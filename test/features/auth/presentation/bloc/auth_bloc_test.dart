import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/auth/domain/entities/user_entity.dart';
import 'package:sra_hotel/features/auth/domain/usecases/login_usecase.dart';
import 'package:sra_hotel/features/auth/domain/usecases/register_usecase.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import '../../domain/usecases/login_usecase_test.dart';

void main() {
  group('AuthBloc Tests', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase loginUseCase;
    late RegisterUseCase registerUseCase;
    late AuthBloc authBloc;

    const testUser = UserEntity(id: '1', login: 'user@srah.com', role: 'CLIENT');

    setUp(() {
      mockRepository = MockAuthRepository(mockUser: testUser);
      loginUseCase = LoginUseCase(mockRepository);
      registerUseCase = RegisterUseCase(mockRepository);
      authBloc = AuthBloc(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
        authRepository: mockRepository,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('l\'état initial doit être AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    test('doit émettre [AuthLoading, Authenticated] lors d\'une connexion réussie', () async {
      final expectedStates = [
        isA<AuthLoading>(),
        isA<Authenticated>(),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(const LoginSubmitted(login: 'user@srah.com', password: 'Password123'));
    });

    test('doit émettre [AuthLoading, AuthFailure] lors d\'une erreur de connexion', () async {
      final failingRepo = MockAuthRepository(shouldThrow: true);
      final failingBloc = AuthBloc(
        loginUseCase: LoginUseCase(failingRepo),
        registerUseCase: RegisterUseCase(failingRepo),
        authRepository: failingRepo,
      );

      final expectedStates = [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ];

      expectLater(failingBloc.stream, emitsInOrder(expectedStates));

      failingBloc.add(const LoginSubmitted(login: 'bad@srah.com', password: 'wrong'));
    });

    test('doit émettre [AuthLoading, Unauthenticated] lors de la déconnexion', () async {
      final expectedStates = [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(LogoutRequested());
    });
  });
}
