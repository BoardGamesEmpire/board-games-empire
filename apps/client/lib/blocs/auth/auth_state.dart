part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.token,
    this.error,
    this.isLoading = false,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user, String? token)
    : this._(status: AuthStatus.authenticated, user: user, token: token);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  const AuthState.loading() : this._(isLoading: true);

  const AuthState.error(String message)
    : this._(status: AuthStatus.unauthenticated, error: message);

  final AuthStatus status;
  final User? user;
  final String? token;
  final String? error;
  final bool isLoading;

  @override
  List<Object?> get props => [status, user, token, error, isLoading];
}
