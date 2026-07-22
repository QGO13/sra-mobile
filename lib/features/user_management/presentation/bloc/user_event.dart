import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';

abstract class UserEvent {}

class LoadUsersEvent extends UserEvent {}

class CreateUserEvent extends UserEvent {
  final StaffUser user;
  CreateUserEvent(this.user);
}

class UpdateUserEvent extends UserEvent {
  final StaffUser user;
  UpdateUserEvent(this.user);
}

class DeleteUserEvent extends UserEvent {
  final int id;
  DeleteUserEvent(this.id);
}
