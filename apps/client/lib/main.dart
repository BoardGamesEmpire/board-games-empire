import 'package:board_games_empire/blocs/platform/platform_bloc.dart';
import 'package:board_games_empire/blocs/utils/app_bloc_observer.dart';
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
import './blocs/settings/theme/theme_bloc.dart';
import './theme/theme_provider.dart';

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

class _BoardGamesEmpireState extends State<BoardGamesEmpire>
    with WidgetsBindingObserver {
  final String title = 'Board Games Empire';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    getIt<ThemeBloc>().add(SystemThemeChanged(brightness));
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => getIt<AppBloc>()..add(const AppStarted()),
        ),
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<RouterBloc>(create: (context) => getIt<RouterBloc>()),
        BlocProvider<ThemeBloc>(create: (context) => getIt<ThemeBloc>()),
        BlocProvider<PlatformBloc>(create: (context) => getIt<PlatformBloc>()),
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
        child: BlocBuilder<ThemeBloc, ThemeState>(
          buildWhen:
              (previous, current) =>
                  previous.themeMode != current.themeMode ||
                  previous.systemBrightness != current.systemBrightness,
          builder: (context, themeState) {
            return BlocBuilder<AppBloc, AppState>(
              buildWhen:
                  (previous, current) => previous.status != current.status,
              builder: (context, appState) {
                if (appState.status == AppStatus.initializing) {
                  return MaterialApp(
                    title: title,
                    theme: ThemeProvider.lightTheme,
                    darkTheme: ThemeProvider.darkTheme,
                    themeMode: themeState.themeMode,
                    home: const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                return MaterialApp.router(
                  title: title,
                  theme: ThemeProvider.lightTheme,
                  darkTheme: ThemeProvider.darkTheme,
                  themeMode: themeState.themeMode,
                  routerConfig: AppRouter.router,
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
