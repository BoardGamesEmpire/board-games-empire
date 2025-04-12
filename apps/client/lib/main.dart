import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/jwt_interceptor.dart';
import 'services/server_config_service.dart';
import 'services/platform_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/account/session_management_screen.dart';
import 'screens/config/server_config_screen.dart';
import 'screens/config/server_selection_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const BoardGamesEmpire());
}

class BoardGamesEmpire extends StatelessWidget {
  final String title = 'Board Games Empire';

  const BoardGamesEmpire({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerConfigService()),

        ChangeNotifierProxyProvider<ServerConfigService, AuthService>(
          create: (_) => AuthService(),
          update: (_, serverConfigService, previousAuthService) {
            final authService = previousAuthService ?? AuthService();

            if (serverConfigService.activeServer != null) {
              authService.setBaseUrl(serverConfigService.activeServer!.url);
              authService.setCurrentServer(
                serverConfigService.activeServer!.id,
              );
            }

            return authService;
          },
        ),

        ProxyProvider2<ServerConfigService, AuthService, JwtHttpClient>(
          update:
              (_, serverConfigService, authService, __) => JwtHttpClient(
                baseUrl: serverConfigService.activeServer?.url ?? '',
                authService: authService,
              ),
        ),
      ],
      child: Consumer<ServerConfigService>(
        builder: (ctx, serverConfigService, _) {
          if (!serverConfigService.isInitialized) {
            Future.microtask(() => serverConfigService.initialize());

            return MaterialApp(
              title: title,
              theme: _buildLightTheme(),
              darkTheme: _buildDarkTheme(),
              themeMode: ThemeMode.system,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return Consumer<AuthService>(
            builder: (ctx, auth, _) {
              Widget initialScreen;

              if (PlatformService.isWeb) {
                initialScreen = const LoginScreen();
              } else if (!serverConfigService.hasServers) {
                initialScreen = const ServerConfigScreen(isInitialSetup: true);
              } else if (!auth.isAuthenticated) {
                initialScreen = const LoginScreen();
              } else {
                initialScreen = const HomeScreen();
              }

              return MaterialApp(
                title: title,
                theme: _buildLightTheme(),
                darkTheme: _buildDarkTheme(),
                themeMode: ThemeMode.system,
                home: initialScreen,
                routes: {
                  LoginScreen.routeName: (ctx) => const LoginScreen(),
                  RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                  ForgotPasswordScreen.routeName:
                      (ctx) => const ForgotPasswordScreen(),
                  HomeScreen.routeName: (ctx) => const HomeScreen(),
                  SessionManagementScreen.routeName:
                      (ctx) => const SessionManagementScreen(),
                  ServerConfigScreen.routeName:
                      (ctx) => const ServerConfigScreen(),
                  ServerSelectionScreen.routeName:
                      (ctx) => const ServerSelectionScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.indigo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo,
        ),
      ),
    );
  }
}
