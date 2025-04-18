import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/injection.dart';
import 'services/auth/auth_service.dart';
import 'services/server_config_service.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencyInjection();

  runApp(const BoardGamesEmpire());
}

class BoardGamesEmpire extends StatefulWidget {
  const BoardGamesEmpire({super.key});

  @override
  State<BoardGamesEmpire> createState() => _BoardGamesEmpireState();
}

class _BoardGamesEmpireState extends State<BoardGamesEmpire> {
  final String title = 'Board Games Empire';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ServerConfigService>.value(
          value: getIt<ServerConfigService>(),
        ),
        ChangeNotifierProvider<AuthService>.value(value: getIt<AuthService>()),
      ],
      child: Consumer<ServerConfigService>(
        builder: (ctx, serverConfigService, _) {
          if (!serverConfigService.isInitialized) {
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

          return MaterialApp.router(
            title: title,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: ThemeMode.system,
            routerConfig: appRouter,
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
