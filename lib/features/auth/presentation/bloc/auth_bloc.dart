import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';
import 'package:sra_hotel/features/auth/domain/usecases/login_usecase.dart';
import 'package:sra_hotel/features/auth/domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegisterParticulierSubmitted>(_onRegisterParticulierSubmitted);
    on<RegisterCompanySubmitted>(_onRegisterCompanySubmitted);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getAuthenticatedUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(
        LoginParams(login: event.login, password: event.password),
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(Unauthenticated());
  }

  Future<void> _onRegisterParticulierSubmitted(
    RegisterParticulierSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.registerParticulier(
        RegisterParticulierParams(
          email: event.email,
          password: event.password,
          nom: event.nom,
          prenoms: event.prenoms,
          telephone: event.telephone,
          sexe: event.sexe,
          pays: event.pays,
          adresse: event.adresse,
        ),
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterCompanySubmitted(
    RegisterCompanySubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.registerCompany(
        RegisterCompanyParams(
          email: event.email,
          password: event.password,
          companyName: event.companyName,
          telephone: event.telephone,
          pays: event.pays,
          adresse: event.adresse,
          isExterne: event.isExterne,
        ),
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}

