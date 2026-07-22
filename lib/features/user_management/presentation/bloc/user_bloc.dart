import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/get_users_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/create_user_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/update_user_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/delete_user_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UserBloc({
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  }) : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final list = await getUsersUseCase();
      emit(UserLoaded(list));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<UserState> emit) async {
    try {
      await createUserUseCase(event.user);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await updateUserUseCase(event.user);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      await deleteUserUseCase(event.id);
      add(LoadUsersEvent());
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}
