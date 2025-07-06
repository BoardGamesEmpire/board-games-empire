import '../../blocs/auth/auth_bloc.dart';
import './user_context_provider.dart';

class AuthUserContextProvider implements UserContextProvider {
  final AuthBloc _authBloc;

  AuthUserContextProvider({required AuthBloc authBloc}) : _authBloc = authBloc;

  @override
  String? get currentUserId => _authBloc.state.user?.id;

  @override
  bool get isAuthenticated =>
      _authBloc.state.status == AuthStatus.authenticated;
}
