import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';
import 'package:sra_hotel/features/user_management/domain/repositories/user_repository.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/create_user_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/delete_user_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/get_users_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/update_user_usecase.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_event.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_state.dart';

class MockUserRepository implements UserRepository {
  final bool shouldThrow;

  MockUserRepository({this.shouldThrow = false});

  @override
  Future<List<StaffUser>> getUsers() async {
    if (shouldThrow) throw Exception('Erreur de chargement utilisateurs');
    return [
      StaffUser(
        id: '1',
        login: 'reception@srah.com',
        role: 'receptionist',
        nom: 'Kouassi',
        prenoms: 'Marc',
        telephone: '+22507080910',
        sexe: 'M',
        pays: 'Côte d\'Ivoire',
        adresse: 'Abidjan',
        isActive: 1,
      ),
    ];
  }

  @override
  Future<StaffUser> createUser(StaffUser user) async => user;

  @override
  Future<StaffUser> updateUser(StaffUser user) async => user;

  @override
  Future<void> deleteUser(int id) async {}
}

void main() {
  group('UserBloc Tests', () {
    late MockUserRepository repository;
    late UserBloc userBloc;

    setUp(() {
      repository = MockUserRepository();
      userBloc = UserBloc(
        getUsersUseCase: GetUsersUseCase(repository),
        createUserUseCase: CreateUserUseCase(repository),
        updateUserUseCase: UpdateUserUseCase(repository),
        deleteUserUseCase: DeleteUserUseCase(repository),
      );
    });

    tearDown(() {
      userBloc.close();
    });

    test('L\'état initial doit être UserInitial', () {
      expect(userBloc.state, isA<UserInitial>());
    });

    test('Doit émettre [UserLoading, UserLoaded] lors du chargement de la liste', () async {
      final expectedStates = [
        isA<UserLoading>(),
        isA<UserLoaded>(),
      ];

      expectLater(userBloc.stream, emitsInOrder(expectedStates));

      userBloc.add(LoadUsersEvent());
    });

    test('Doit émettre [UserLoading, UserFailure] en cas d\'erreur de chargement', () async {
      final failingRepo = MockUserRepository(shouldThrow: true);
      final failingBloc = UserBloc(
        getUsersUseCase: GetUsersUseCase(failingRepo),
        createUserUseCase: CreateUserUseCase(failingRepo),
        updateUserUseCase: UpdateUserUseCase(failingRepo),
        deleteUserUseCase: DeleteUserUseCase(failingRepo),
      );

      final expectedStates = [
        isA<UserLoading>(),
        isA<UserFailure>(),
      ];

      expectLater(failingBloc.stream, emitsInOrder(expectedStates));

      failingBloc.add(LoadUsersEvent());
    });
  });
}
