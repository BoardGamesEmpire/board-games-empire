import 'package:board_games_empire/blocs/utils/app_bloc_ovserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import './di/injection.dart';
import './services/auth/auth_service.dart';
import './services/server_config_service.dart';
import './router/app_router.dart';
import './blocs/auth/auth_bloc.dart';
import './blocs/app/app_bloc.dart';
import './blocs/router/router_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up BLoC observer for debugging
  Bloc.observer = AppBlocObserver();

  // Initialize dependency injection
  await setupDependencyInjection();

  // Initialize the router
  AppRouter.initialize();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => getIt<AppBloc>()..add(const AppStarted()),
        ),
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<RouterBloc>(create: (context) => getIt<RouterBloc>()),
        // Add other global BLoCs here
      ],
      child: MultiProvider(
        providers: [
          // Keep these for backward compatibility while refactoring
          ChangeNotifierProvider<ServerConfigService>.value(
            value: getIt<ServerConfigService>(),
          ),
          ChangeNotifierProvider<AuthService>.value(
            value: getIt<AuthService>(),
          ),
        ],
        child: BlocBuilder<AppBloc, AppState>(
          buildWhen:
              (previous, current) =>
                  previous.themeMode != current.themeMode ||
                  previous.status != current.status,
          builder: (context, state) {
            if (state.status == AppStatus.initializing) {
              return MaterialApp(
                title: title,
                theme: _buildLightTheme(),
                darkTheme: _buildDarkTheme(),
                themeMode: state.themeMode,
                home: const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            return MaterialApp.router(
              title: title,
              theme: _buildLightTheme(),
              darkTheme: _buildDarkTheme(),
              themeMode: state.themeMode,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
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
