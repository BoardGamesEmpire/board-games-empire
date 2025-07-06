import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'package:board_games_empire/blocs/server/server_config/server_config_bloc.dart';
import './blocs/app/app_bloc.dart';
import './blocs/app/initialization/app_initialization_bloc.dart';
import './blocs/auth/auth_bloc.dart';
import './blocs/error/error_bloc.dart';
import './blocs/platform/platform_bloc.dart';
import './blocs/settings/theme/theme_bloc.dart';
import './blocs/utils/app_bloc_observer.dart';
import './blocs/websocket/websocket_bloc.dart';

import './di/coordinator.dart';
import './di/injection.dart';
import './router/app_router.dart';
import './theme/theme_provider.dart';
import './widgets/app/error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  GoRouter.optionURLReflectsImperativeAPIs = true;
  Bloc.observer = AppBlocObserver();

  await setupDependencyInjection();

  getIt<BlocCoordinator>();

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
        BlocProvider<ThemeBloc>(create: (context) => getIt<ThemeBloc>()),
        BlocProvider<PlatformBloc>(create: (context) => getIt<PlatformBloc>()),
        BlocProvider(create: (context) => getIt<WebSocketBloc>()),
        BlocProvider<ServerConfigBloc>(
          create: (context) => getIt<ServerConfigBloc>(),
        ),
        BlocProvider<AppInitializationBloc>(
          create:
              (context) =>
                  getIt<AppInitializationBloc>()..add(const AppInitStarted()),
        ),
        BlocProvider<ErrorBloc>(create: (context) => getIt<ErrorBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        buildWhen:
            (previous, current) =>
                previous.themeMode != current.themeMode ||
                previous.systemBrightness != current.systemBrightness,
        builder: (context, themeState) {
          return MaterialApp.router(
            title: title,
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return ErrorHandler(child: child ?? const SizedBox());
            },
          );
        },
      ),
    );
  }
}
