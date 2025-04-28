import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './route_constants.dart';
import '../di/injection.dart';

import '../blocs/websocket/websocket_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/account/account_bloc.dart';
import '../blocs/auth/password_reset/password_reset_form_bloc.dart';
import '../blocs/auth/forgot_password/forgot_password_bloc.dart';
import '../blocs/auth/login/login_bloc.dart';
import '../blocs/platform/platform_bloc.dart';
import '../blocs/auth/register/register_bloc.dart';
import '../blocs/auth/session/session_bloc.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/game/game_search/game_search_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/router/router_bloc.dart';
import '../blocs/server/selection/server_selection_bloc.dart';
import '../blocs/server/server_config/server_config_bloc.dart';
import '../blocs/settings/theme/theme_bloc.dart';

import '../repositories/auth/auth_repository.dart';

import '../screens/settings/connection_settings_screen.dart';
import '../screens/websocket/websocket_settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/account/account_screen.dart';
import '../screens/auth/password_reset_screen.dart';
import '../screens/account/session_management_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/config/server_config_screen.dart';
import '../screens/config/server_selection_screen.dart';
import '../screens/game/game_search_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/theme/theme_settings_screen.dart';

class BlocRouterDelegate {
  final routerNotifier = ValueNotifier<String>('/');
  late final GoRouter router;

  BlocRouterDelegate() {
    router = GoRouter(
      refreshListenable: routerNotifier,
      initialLocation: '/',
      redirect: _handleRedirect,
      routes: _buildRoutes(),
      errorBuilder: _buildErrorPage,
    );

    // Listen to RouterBloc state changes
    getIt<RouterBloc>().stream.listen((state) {
      _handleRouterState(state);
    });
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final isAuthenticated = authBloc.state.status == AuthStatus.authenticated;
    final platformBloc = context.read<PlatformBloc>();

    // Special paths that can be accessed without a server or authentication
    final noServerRequiredPaths = [
      AppRoutes.serverConfig,
      AppRoutes.serverSelection,
    ];

    // Paths that can be accessed without authentication
    final noAuthRequiredPaths = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
      ...noServerRequiredPaths,
    ];

    final isNoServerPath = noServerRequiredPaths.contains(
      state.matchedLocation,
    );
    final isNoAuthPath = noAuthRequiredPaths.contains(state.matchedLocation);

    if (platformBloc.state.isWeb) {
      if (!isAuthenticated && !isNoAuthPath) {
        return AppRoutes.login;
      }
      return null;
    }

    final servers = [];

    if (servers.isEmpty && !isNoServerPath) {
      return '${AppRoutes.serverConfig}?initial=true';
    }

    if (!isAuthenticated && !isNoAuthPath) {
      // Save the attempted path to redirect back after login
      final location = router.routerDelegate.currentConfiguration.lastOrNull;
      final queryParams = {'from': location ?? '/'};
      return '${AppRoutes.login}?${Uri(queryParameters: queryParams).query}';
    }

    // If authenticated but going to auth screens, redirect to home
    if (isAuthenticated && isNoAuthPath && !isNoServerPath) {
      return AppRoutes.home;
    }

    return null;
  }

  void _handleRouterState(RouterState state) {
    switch (state.navigationMethod) {
      case NavigationMethod.push:
        router.push(state.location, extra: state.navigationArgs);
        break;
      case NavigationMethod.pop:
        router.pop(state.navigationResult);
        break;
      case NavigationMethod.replace:
        router.replace(state.location, extra: state.navigationArgs);
        break;
      case NavigationMethod.goToRoot:
        router.go(state.location);
        break;
      case NavigationMethod.none:
        // No navigation needed, just update the current location
        routerNotifier.value = state.location;
        break;
    }
  }

  List<RouteBase> _buildRoutes() {
    return [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return _buildLoginScreen(from);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => _buildRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => _buildForgotPasswordScreen(),
      ),

      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'passwordReset',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return BlocProvider(
            create: (context) => getIt<PasswordResetFormBloc>(),
            child: PasswordResetScreen(token: token),
          );
        },
      ),

      GoRoute(
        path: '/account',
        name: 'account',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<AccountBloc>(),
            child: const AccountScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.themeSettings,
        name: 'themeSettings',
        builder: (context, state) => _buildThemeSettingsScreen(),
      ),

      GoRoute(
        path: AppRoutes.connectionSettings,
        name: 'connectionSettings',
        builder: (context, state) {
          return const ConnectionSettingsScreen();
        },
      ),

      // Main app routes
      GoRoute(path: '/', redirect: (_, __) => AppRoutes.home),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => _buildHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.sessionManagement,
        name: 'sessions',
        builder: (context, state) => _buildSessionManagementScreen(),
      ),

      GoRoute(
        path: AppRoutes.websocketSettings,
        name: 'websocketSettings',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<WebSocketBloc>(),
            child: const WebSocketSettingsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.serverConfig,
        name: 'serverConfig',
        builder: (context, state) {
          final isInitial = state.uri.queryParameters['initial'] == 'true';
          return _buildServerConfigScreen(isInitial);
        },
      ),
      GoRoute(
        path: AppRoutes.serverSelection,
        name: 'serverSelection',
        builder: (context, state) => _buildServerSelectionScreen(),
      ),

      // Feature routes
      GoRoute(
        path: AppRoutes.gameSearch,
        name: 'gameSearch',
        builder: (context, state) => _buildGameSearchScreen(),
      ),

      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (context, state) => _buildChatScreen(),
      ),

      GoRoute(
        path: AppRoutes.gameDetails,
        name: 'gameDetails',
        builder: (context, state) {
          final gameId = state.pathParameters['id']!;
          return _buildGameDetailsScreen(gameId);
        },
      ),
    ];
  }

  // Screen builders
  Widget _buildLoginScreen(String? redirectPath) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: LoginScreen(redirectPath: redirectPath),
    );
  }

  Widget _buildRegisterScreen() {
    return BlocProvider(
      create: (context) => getIt<RegisterBloc>(),
      child: const RegisterScreenBloc(),
    );
  }

  Widget _buildForgotPasswordScreen() {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: const ForgotPasswordScreenBloc(),
    );
  }

  Widget _buildHomeScreen() {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: const HomeScreenBloc(),
    );
  }

  Widget _buildThemeSettingsScreen() {
    return BlocProvider(
      create: (context) => getIt<ThemeBloc>(),
      child: const ThemeSettingsScreen(),
    );
  }

  Widget _buildServerConfigScreen(bool isInitialSetup) {
    return BlocProvider(
      create: (context) => getIt<ServerConfigBloc>(),
      child: ServerConfigScreenBloc(isInitialSetup: isInitialSetup),
    );
  }

  Widget _buildServerSelectionScreen() {
    return BlocProvider(
      create: (context) => getIt<ServerSelectionBloc>(),
      child: const ServerSelectionScreenBloc(),
    );
  }

  Widget _buildSessionManagementScreen() {
    return BlocProvider(
      create: (context) => getIt<SessionBloc>(),
      child: const SessionManagementScreenBloc(),
    );
  }

  Widget _buildGameSearchScreen() {
    return BlocProvider(
      create: (context) => getIt<GameSearchBloc>(),
      child: const GameSearchScreenBloc(),
    );
  }

  Widget _buildChatScreen() {
    return BlocProvider(
      create: (context) => getIt<ChatBloc>(),
      child: const ChatScreenBloc(),
    );
  }

  Widget _buildGameDetailsScreen(String gameId) {
    // TODO: GameDetailsBloc
    return Container();
  }

  Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    return Scaffold(
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
              onPressed: () => router.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
