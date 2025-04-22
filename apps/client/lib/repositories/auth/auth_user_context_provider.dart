import './user_context_provider.dart';
import '../../services/auth/auth_service.dart';

class AuthUserContextProvider implements UserContextProvider {
  final AuthService _authRepo;

  AuthUserContextProvider({required AuthService authService})
    : _authRepo = authService;

  @override
  String? get currentUserId => _authRepo.currentUser?.id;

  @override
  bool get isAuthenticated => _authRepo.isAuthenticated;
}
