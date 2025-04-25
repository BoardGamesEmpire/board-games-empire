part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountInitialized extends AccountEvent {
  const AccountInitialized();
}

class UserDataUpdated extends AccountEvent {
  final User user;

  const UserDataUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class AccountNameChanged extends AccountEvent {
  final String firstName;
  final String lastName;

  const AccountNameChanged({required this.firstName, required this.lastName});

  @override
  List<Object> get props => [firstName, lastName];
}

class AccountEmailChanged extends AccountEvent {
  final String email;

  const AccountEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class AccountUsernameChanged extends AccountEvent {
  final String username;

  const AccountUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class AccountPasswordChanged extends AccountEvent {
  final String password;

  const AccountPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class AccountCurrentPasswordChanged extends AccountEvent {
  final String password;

  const AccountCurrentPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class AccountPasswordChangeRequested extends AccountEvent {
  const AccountPasswordChangeRequested();
}

class AccountProfileUpdateRequested extends AccountEvent {
  const AccountProfileUpdateRequested();
}
