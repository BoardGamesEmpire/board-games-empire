import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/account/session_management_screen.dart';
import '../screens/config/server_config_screen.dart';
import '../screens/config/server_selection_screen.dart';
import '../screens/game/game_search_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../services/auth/auth_service.dart';
import '../services/server_config_service.dart';
import '../services/platform_service.dart';
import 'route_constants.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  refreshListenable: GoRouterRefreshStream(getIt<AuthService>().onLogout),
  initialLocation: '/',
  redirect: (context, state) {
    final authService = getIt<AuthService>();
    final serverConfigService = getIt<ServerConfigService>();
    final isAuthenticated = authService.isAuthenticated;

    // Special paths that can be accessed without a server or authentication
    final noServerRequiredPaths = ['/server-config', '/server-selection'];

    // Paths that can be accessed without authentication
    final noAuthRequiredPaths = [
      AppRoutes.login,
      '/register',
      '/forgot-password',
      ...noServerRequiredPaths,
    ];

    final isNoServerPath = noServerRequiredPaths.contains(
      state.matchedLocation,
    );
    final isNoAuthPath = noAuthRequiredPaths.contains(state.matchedLocation);

    // Handle web platform case
    if (PlatformService.isWeb) {
      if (!isAuthenticated && !isNoAuthPath) {
        return AppRoutes.login;
      }
      return null;
    }

    // Handle server selection & config
    if (!serverConfigService.hasServers && !isNoServerPath) {
      return '/server-config?initial=true';
    }

    // Handle authentication
    if (!isAuthenticated && !isNoAuthPath) {
      // Save the attempted path to redirect back after login
      final queryParams = {'from': state.matchedLocation};
      return '${AppRoutes.login}?${Uri(queryParameters: queryParams).query}';
    }

    // If authenticated but going to auth screens, redirect to home
    if (isAuthenticated && isNoAuthPath && !isNoServerPath) {
      return '/home';
    }

    return null;
  },
  routes: [
    // Auth routes
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'];
        return LoginScreen(redirectPath: from);
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Main app routes
    GoRoute(path: '/', redirect: (context, state) => '/home'),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/sessions',
      name: 'sessions',
      builder: (context, state) => const SessionManagementScreen(),
    ),

    // Config routes
    GoRoute(
      path: '/server-config',
      name: 'serverConfig',
      builder: (context, state) {
        final isInitial = state.uri.queryParameters['initial'] == 'true';
        return ServerConfigScreen(isInitialSetup: isInitial);
      },
    ),
    GoRoute(
      path: '/server-selection',
      name: 'serverSelection',
      builder: (context, state) => const ServerSelectionScreen(),
    ),

    // Feature routes
    GoRoute(
      path: '/games/search',
      name: 'gameSearch',
      builder: (context, state) => const GameSearchScreen(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatScreen(),
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${state.error?.message ?? "Page not found"}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => appRouter.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
);
