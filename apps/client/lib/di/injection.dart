import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

// Context providers
import '../repositories/auth/user_context_provider.dart';

import '../handlers/network_error_handler.dart';

import '../di/coordinator.dart';

// Repositories
import '../repositories/auth/auth_repository.dart';
import '../repositories/chat/chat_repository.dart';
import '../repositories/game/game_repository.dart';
import '../repositories/server/server_repository.dart';
import '../repositories/websocket/websocket_repository.dart';
import '../repositories/auth/auth_user_context_provider.dart';

// Data sources
import '../data/api/auth_api.dart';
import '../data/api/chat_api.dart';
import '../data/api/game_api.dart';
import '../data/datasources/game_websocket_data_source.dart';
import '../data/datasources/game_rest_data_source.dart';
import '../data/local/secure_storage.dart';
import '../data/local/user_preferences.dart';
import '../data/websocket/websocket_client.dart';

// Blocs
import '../blocs/app/app_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/websocket/websocket_bloc.dart';
import '../blocs/auth/forgot_password/forgot_password_bloc.dart';
import '../blocs/auth/login/login_bloc.dart';
import '../blocs/auth/register/register_bloc.dart';
import '../blocs/auth/session/session_bloc.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/connection/connection_bloc.dart';
import '../blocs/game/game_collection/game_collection_bloc.dart';
import '../blocs/game/game_search/game_search_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/account/account_bloc.dart';
import '../blocs/app/initialization/app_initialization_bloc.dart';
import '../blocs/auth/password_reset/password_reset_form_bloc.dart';
import '../blocs/error/error_bloc.dart';
import '../blocs/platform/platform_bloc.dart';
import '../blocs/router/router_bloc.dart';
import '../blocs/server/selection/server_selection_bloc.dart';
import '../blocs/server/server_bloc.dart';
import '../blocs/server/server_config/server_config_bloc.dart';
import '../blocs/settings/theme/theme_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupDependencyInjection() async {
  await registerWebSocketDependencies(getIt);
  await registerServerConfigDependencies(getIt);

  _registerContextProviders();

  await _registerServices();
  await _registerRepositories();
  await _registerBlocs();
}

Future<void> registerWebSocketDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<WebSocketClient>(
    () => WebSocketClient(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<WebSocketRepository>(
    () => WebSocketRepository(websocketClient: getIt<WebSocketClient>()),
  );

  getIt.registerLazySingleton<GameWebSocketDataSource>(
    () => GameWebSocketDataSource(webSocketClient: getIt<WebSocketClient>()),
  );

  getIt.registerLazySingleton<GameRepository>(
    () => GameRepository(
      restDataSource: getIt<GameRestDataSource>(),
      webSocketDataSource: getIt<GameWebSocketDataSource>(),
      websocketRepository: getIt<WebSocketRepository>(),
      userContextProvider: getIt<UserContextProvider>(),
      errorBloc: getIt<ErrorBloc>(),
    ),
  );

  getIt.registerFactory<ChatRepository>(
    () => ChatRepository(
      chatApi: getIt<ChatApi>(),
      websocketRepository: getIt<WebSocketRepository>(),
    ),
  );

  getIt.registerFactory<ConnectionBloc>(
    () => ConnectionBloc(websocketRepository: getIt<WebSocketRepository>()),
  );
}

Future<void> _registerServices() async {
  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Local data sources
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorage(storage: getIt<FlutterSecureStorage>()),
  );
}

void _registerContextProviders() {
  getIt.registerLazySingleton<UserContextProvider>(
    () => AuthUserContextProvider(authBloc: getIt<AuthBloc>()),
  );
}

Future<void> _registerRepositories() async {
  final serverRepo = getIt<ServerRepository>();
  final baseUrl = serverRepo.activeServer?.url ?? '';

  // API clients
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(baseUrl: baseUrl));
  getIt.registerLazySingleton<ChatApi>(() => ChatApi(baseUrl: baseUrl));
  getIt.registerLazySingleton<GameApi>(() => GameApi(baseUrl: baseUrl));

  getIt.registerLazySingleton<GameRestDataSource>(
    () => GameRestDataSource(gameApi: getIt<GameApi>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      authApi: getIt<AuthApi>(),
      secureStorage: getIt<SecureStorage>(),
      userPreferences: getIt<UserPreferences>(),
    ),
  );
}

Future<void> _registerBlocs() async {
  getIt.registerLazySingleton<AppBloc>(
    () => AppBloc(
      connectionChecker: getIt<InternetConnectionChecker>(),
      webSocketBloc: getIt<WebSocketBloc>(),
      initializationBloc: getIt.get<AppInitializationBloc>(),
    ),
  );

  getIt.registerFactory<AppInitializationBloc>(
    () => AppInitializationBloc(
      serverRepository: getIt<ServerRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<BlocCoordinator>(() {
    final appBloc = getIt<AppBloc>();
    final initBloc = getIt<AppInitializationBloc>();

    // Set up coordination between blocs
    return BlocCoordinator(appBloc: appBloc, initializationBloc: initBloc);
  }, dispose: (coordinator) => coordinator.dispose());

  getIt.registerLazySingleton<ErrorBloc>(() => ErrorBloc());

  getIt.registerLazySingleton<NetworkErrorHandler>(
    () => NetworkErrorHandler(errorBloc: getIt<ErrorBloc>())..initialize(),
  );

  getIt.registerLazySingleton<PlatformBloc>(
    () => PlatformBloc()..add(const PlatformInitialized()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<WebSocketBloc>(
    () => WebSocketBloc(
      websocketRepository: getIt<WebSocketRepository>(),
      errorBloc: getIt<ErrorBloc>(),
    ),
  );

  getIt.registerLazySingleton<RouterBloc>(() => RouterBloc());

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<PasswordResetFormBloc>(
    () => PasswordResetFormBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<AccountBloc>(
    () => AccountBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<ServerSelectionBloc>(
    () => ServerSelectionBloc(
      serverRepository: getIt<ServerRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<ThemeBloc>(
    () =>
        ThemeBloc(preferences: getIt<SharedPreferences>())
          ..add(const ThemeInitialized()),
  );

  getIt.registerFactory<SessionBloc>(
    () => SessionBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      websocketRepository: getIt<WebSocketRepository>(),
      authRepository: getIt<AuthRepository>(),
      serverConfigBloc: getIt<ServerConfigBloc>(),
    ),
  );

  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<ServerBloc>(
    () => ServerBloc(serverRepository: getIt<ServerRepository>()),
  );

  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(chatRepository: getIt<ChatRepository>()),
  );

  getIt.registerFactory<GameSearchBloc>(
    () => GameSearchBloc(gameRepository: getIt<GameRepository>()),
  );

  getIt.registerFactory<GameCollectionBloc>(
    () => GameCollectionBloc(gameRepository: getIt<GameRepository>()),
  );
}

void resetAppServices() {
  if (getIt.isRegistered<WebSocketClient>()) {
    final wsClient = getIt<WebSocketClient>();
    wsClient.dispose();
  }

  if (getIt.isRegistered<ChatRepository>()) {
    final chatRepo = getIt<ChatRepository>();
    chatRepo.dispose();
  }

  // Reset feature blocs
  getIt.resetLazySingleton<AuthBloc>();

  // Re-register feature blocs
  _registerBlocs();
}

void resetWebSocketServices() {
  // Close WebSocket connections
  if (getIt.isRegistered<WebSocketClient>()) {
    final wsClient = getIt<WebSocketClient>();
    wsClient.dispose();
    getIt.resetLazySingleton<WebSocketClient>();
  }

  if (getIt.isRegistered<WebSocketRepository>()) {
    final wsRepo = getIt<WebSocketRepository>();
    wsRepo.dispose();
    getIt.resetLazySingleton<WebSocketRepository>();
  }

  // Reset feature repositories
  if (getIt.isRegistered<ChatRepository>()) {
    final chatRepo = getIt<ChatRepository>();
    chatRepo.dispose();
    getIt.resetLazySingleton<ChatRepository>();
  }

  if (getIt.isRegistered<GameRepository>()) {
    final gameRepo = getIt<GameRepository>();
    gameRepo.dispose();
    getIt.resetLazySingleton<GameRepository>();
  }

  // Re-register repositories and services
  registerWebSocketDependencies(getIt);
}

Future<void> registerServerConfigDependencies(GetIt getIt) async {
  if (!getIt.isRegistered<UserPreferences>()) {
    getIt.registerLazySingleton<UserPreferences>(() => UserPreferences());
    await getIt<UserPreferences>().init();
  }

  // Register ServerRepository
  getIt.registerLazySingleton<ServerRepository>(
    () => ServerRepository(
      userPreferences: getIt<UserPreferences>(),
      isWebPlatform: kIsWeb,
    ),
  );

  await getIt<ServerRepository>().initialize();

  getIt.registerFactory<ServerConfigBloc>(
    () => ServerConfigBloc(
      serverRepository: getIt<ServerRepository>(),
      authRepository: getIt<AuthRepository>(),
      websocketRepository:
          getIt.isRegistered<WebSocketRepository>()
              ? getIt<WebSocketRepository>()
              : null,
    ),
  );
}

void resetServerConfigServices() {
  // Reset ServerConfigBloc dependencies
  if (getIt.isRegistered<ServerConfigBloc>()) {
    getIt.resetLazySingleton<ServerConfigBloc>();
  }

  // Reset ServerRepository
  if (getIt.isRegistered<ServerRepository>()) {
    getIt.resetLazySingleton<ServerRepository>();
  }

  // Re-register repositories and services
  registerServerConfigDependencies(getIt);
}
