import 'package:sra_hotel/features/user_management/domain/entities/staff_user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<StaffUser> users;
  UserLoaded(this.users);
}

class UserFailure extends UserState {
  final String error;
  UserFailure(this.error);
}
