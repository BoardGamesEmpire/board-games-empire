import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/account/account_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/forgot_password/forgot_password_bloc.dart';
import '../blocs/auth/login/login_bloc.dart';
import '../blocs/auth/password_reset/password_reset_form_bloc.dart';
import '../blocs/auth/register/register_bloc.dart';
import '../blocs/auth/session/session_bloc.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/game/game_gateway/game_gateway_bloc.dart';
import '../blocs/game/game_search/game_search_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/platform/platform_bloc.dart';
import '../blocs/server/server_config/server_config_bloc.dart';
import '../blocs/websocket/websocket_bloc.dart';
import '../di/injection.dart';
import '../screens/account/account_screen.dart';
import '../screens/account/session_management_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/password_reset_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/config/server_config_screen.dart';
import '../screens/config/server_selection_screen.dart';
import '../screens/game/game_gateway/game_gateway_screen.dart';
import '../screens/game/game_search_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/settings/connection_settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/theme/theme_settings_screen.dart';
import '../screens/websocket/websocket_settings_screen.dart';
import 'auth_router_notifier.dart';
import 'route_constants.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // The AuthRouterNotifier will trigger redirects when auth state changes.
    refreshListenable: AuthRouterNotifier(authBloc: getIt<AuthBloc>()),
    initialLocation: '/',
    debugLogDiagnostics: true, // Enable this for helpful console logging
    routes: _buildRoutes(),
    redirect: _handleRedirect,
    errorBuilder:
        (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.error?.message ?? "Page not found"}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.goNamed(AppRouteNames.home),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
  );

  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final serverConfigBloc = context.read<ServerConfigBloc>();
    final platformBloc = context.read<PlatformBloc>();

    final isAuthenticated = authBloc.state.status == AuthStatus.authenticated;
    final servers = serverConfigBloc.state.servers;

    final noServerRequiredPaths = [
      AppRoutes.serverConfig,
      AppRoutes.serverSelection,
    ];

    final noAuthRequiredPaths = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
      AppRoutes.resetPassword,
      ...noServerRequiredPaths,
    ];

    final matchedLocation = state.matchedLocation;
    final isNoServerPath = noServerRequiredPaths.any(
      (path) => matchedLocation.startsWith(path),
    );
    final isNoAuthPath = noAuthRequiredPaths.any(
      (path) => matchedLocation.startsWith(path),
    );

    // On non-web platforms, if no servers are configured, force server setup.
    if (!platformBloc.state.isWeb && servers.isEmpty && !isNoServerPath) {
      return '${AppRoutes.serverConfig}?initial=true';
    }

    // If user is not authenticated and not heading to a page that's allowed without auth, redirect to login.
    if (!isAuthenticated && !isNoAuthPath) {
      return AppRoutes.login;
    }

    // If user is authenticated and trying to access an auth page (that isn't also a server setup page), redirect to home.
    if (isAuthenticated && isNoAuthPath && !isNoServerPath) {
      return AppRoutes.home;
    }

    return null;
  }

  static List<RouteBase> _buildRoutes() {
    return [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        name: AppRouteNames.login,
        path: AppRoutes.login,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<LoginBloc>(),
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.register,
        path: AppRoutes.register,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<RegisterBloc>(),
              child: const RegisterScreenBloc(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.forgotPassword,
        path: AppRoutes.forgotPassword,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<ForgotPasswordBloc>(),
              child: const ForgotPasswordScreenBloc(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.resetPassword,
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return BlocProvider(
            create: (context) => getIt<PasswordResetFormBloc>(),
            child: PasswordResetScreen(token: token),
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.home,
        path: AppRoutes.home,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<HomeBloc>(),
              child: const HomeScreenBloc(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.account,
        path: AppRoutes.account,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<AccountBloc>(),
              child: const AccountScreen(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.sessionManagement,
        path: AppRoutes.sessionManagement,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<SessionBloc>(),
              child: const SessionManagementScreenBloc(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.serverConfig,
        path: AppRoutes.serverConfig,
        builder: (context, state) {
          final isInitial = state.uri.queryParameters['initial'] == 'true';
          return BlocProvider(
            create: (context) => getIt<ServerConfigBloc>(),
            child: ServerConfigScreenBloc(isInitialSetup: isInitial),
          );
        },
      ),

      GoRoute(
        name: AppRouteNames.serverEdit,
        path: AppRoutes.serverEdit,
        builder: (context, state) {
          final serverId = state.pathParameters['serverId']!;
          final serverData = state.extra as Map<String, dynamic>?;

          return BlocProvider(
            create: (context) => getIt<ServerConfigBloc>(),
            child: ServerConfigScreenBloc(
              serverId: serverId,
              initialName: serverData?['name'] as String?,
              initialUrl: serverData?['url'] as String?,
            ),
          );
        },
      ),

      GoRoute(
        name: AppRouteNames.serverSelection,
        path: AppRoutes.serverSelection,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<ServerConfigBloc>(),
              child: const ServerSelectionScreenBloc(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.themeSettings,
        path: AppRoutes.themeSettings,
        builder: (context, state) => const ThemeSettingsScreen(),
      ),
      GoRoute(
        name: AppRouteNames.connectionSettings,
        path: AppRoutes.connectionSettings,
        builder: (context, state) => const ConnectionSettingsScreen(),
      ),
      GoRoute(
        name: AppRouteNames.websocketSettings,
        path: AppRoutes.websocketSettings,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<WebSocketBloc>(),
              child: const WebSocketSettingsScreen(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.gameGateways,
        path: AppRoutes.gameGateways,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<GameGatewayBloc>(),
              child: const GameGatewayScreen(),
            ),
      ),
      GoRoute(
        name: AppRouteNames.gameSearch,
        path: AppRoutes.gameSearch,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<GameSearchBloc>(),
              child: const GameSearchScreenBloc(),
            ),
      ),

      GoRoute(
        name: AppRouteNames.chat,
        path: AppRoutes.chat,
        builder:
            (context, state) => BlocProvider(
              create: (context) => getIt<ChatBloc>(),
              child: const ChatScreenBloc(),
            ),
      ),
    ];
  }
}
