import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';

abstract class UserRepository {
  Future<List<StaffUser>> getUsers();
  Future<StaffUser> createUser(StaffUser user);
  Future<StaffUser> updateUser(StaffUser user);
  Future<void> deleteUser(int id);
}
