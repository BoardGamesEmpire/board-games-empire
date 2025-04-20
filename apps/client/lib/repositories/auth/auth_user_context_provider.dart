import './user_context_provider.dart';
import '../../services/auth/auth_service.dart';

class AuthUserContextProvider implements UserContextProvider {
  final AuthService _authService;

  AuthUserContextProvider({required AuthService authService})
    : _authService = authService;

  @override
  String? get currentUserId => _authService.currentUser?.id;

  @override
  bool get isAuthenticated => _authService.isAuthenticated;
}
