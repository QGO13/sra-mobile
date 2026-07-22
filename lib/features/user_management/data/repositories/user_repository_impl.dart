import 'package:sra_hotel/features/user_management/data/datasources/user_remote_data_source.dart';
import 'package:sra_hotel/features/user_management/data/models/staff_user_model.dart';
import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';
import 'package:sra_hotel/features/user_management/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<StaffUser>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<StaffUser> createUser(StaffUser user) async {
    return await remoteDataSource.createUser(
      StaffUserModel(
        id: user.id,
        login: user.login,
        role: user.role,
        nom: user.nom,
        prenoms: user.prenoms,
        telephone: user.telephone,
        sexe: user.sexe,
        pays: user.pays,
        adresse: user.adresse,
        isActive: user.isActive,
      ),
    );
  }

  @override
  Future<StaffUser> updateUser(StaffUser user) async {
    return await remoteDataSource.updateUser(
      StaffUserModel(
        id: user.id,
        login: user.login,
        role: user.role,
        nom: user.nom,
        prenoms: user.prenoms,
        telephone: user.telephone,
        sexe: user.sexe,
        pays: user.pays,
        adresse: user.adresse,
        isActive: user.isActive,
      ),
    );
  }

  @override
  Future<void> deleteUser(int id) async {
    await remoteDataSource.deleteUser(id);
  }
}
