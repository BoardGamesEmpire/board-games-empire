part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged(this.status, [this.token]);

  final AuthStatus status;
  final String? token;

  @override
  List<Object?> get props => [status, token];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested({this.allSessions = false});

  final bool allSessions;

  @override
  List<Object> get props => [allSessions];
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.deviceInfo,
  });

  final String email;
  final String password;
  final Map<String, dynamic>? deviceInfo;

  @override
  List<Object?> get props => [email, password, deviceInfo];
}

class AuthSessionUpdated extends AuthEvent {
  const AuthSessionUpdated(this.token);

  final String token;

  @override
  List<Object> get props => [token];
}

class AuthServerChanged extends AuthEvent {
  const AuthServerChanged(this.serverId);

  final String serverId;

  @override
  List<Object> get props => [serverId];
}
