import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Context providers
import '../repositories/auth/auth_user_context_provider.dart';
import '../repositories/auth/user_context_provider.dart';

// Repositories
import '../repositories/auth/auth_repository.dart';
import '../repositories/chat/chat_repository.dart';
import '../repositories/game/game_repository.dart';
import '../repositories/server/server_repository.dart';
import '../repositories/websocket/websocket_repository.dart';

// Data sources
import '../data/api/auth_api.dart';
import '../data/api/chat_api.dart';
import '../data/api/game_api.dart';
import '../data/datasources/game_rest_data_source.dart';
import '../data/datasources/game_websocket_data_source.dart';
import '../data/local/secure_storage.dart';
import '../data/local/user_preferences.dart';
import '../data/websocket/websocket_client.dart';

// Blocs
import '../blocs/app/app_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/forgot_password/forgot_password_bloc.dart';
import '../blocs/auth/login/login_bloc.dart';
import '../blocs/auth/register/register_bloc.dart';
import '../blocs/auth/session/session_bloc.dart';
import '../blocs/chat/chat_bloc.dart';
import '../blocs/connection/connection_bloc.dart';
import '../blocs/game/game_collection/game_collection_bloc.dart';
import '../blocs/game/game_search/game_search_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/platform/platform_bloc.dart';
import '../blocs/router/router_bloc.dart';
import '../blocs/server/selection/server_selection_bloc.dart';
import '../blocs/server/server_bloc.dart';
import '../blocs/server/server_config/server_config_bloc.dart';
import '../blocs/settings/theme/theme_bloc.dart';

// Services
import '../services/server_config_service.dart';
import '../services/auth/auth_service.dart';
import '../services/websocket/websocket_manager.dart';
import '../services/jwt_interceptor.dart';
import '../services/chat/chat_service.dart';
import '../services/game/game_service.dart';

import '../providers/platform_provider.dart';

final GetIt getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupDependencyInjection() async {
  _registerContextProviders();
  await _registerCoreServices();

  await _registerServices();
  await _registerRepositories();
  await _registerBlocs();
  await _initializeServices();

  _setupServiceDependencies();
}

void _registerContextProviders() {
  getIt.registerLazySingleton<UserContextProvider>(
    () => AuthUserContextProvider(authService: getIt<AuthService>()),
  );
}

Future<void> _registerServices() async {
  // External services
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

  getIt.registerLazySingleton<UserPreferences>(() => UserPreferences());
}

Future<void> _registerCoreServices() async {
  getIt.registerLazySingleton<ServerConfigService>(() => ServerConfigService());
  getIt.registerLazySingleton<WebSocketManager>(() => WebSocketManager());

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<JwtHttpClient>(
    () => JwtHttpClient(
      baseUrl: getIt<ServerConfigService>().activeServer?.url ?? '',
      authService: getIt<AuthService>(),
    ),
  );
}

Future<void> _initializeServices() async {
  await getIt<ServerConfigService>().initialize();

  PlatformProvider.initialize(getIt<PlatformBloc>());
}

void _setupServiceDependencies() {
  final serverConfigService = getIt<ServerConfigService>();
  final authService = getIt<AuthService>();

  if (serverConfigService.activeServer != null) {
    authService.setBaseUrl(serverConfigService.activeServer!.url);
    authService.setCurrentServer(serverConfigService.activeServer!.id);
  }

  serverConfigService.addListener(() {
    if (serverConfigService.activeServer != null) {
      authService.setBaseUrl(serverConfigService.activeServer!.url);
      authService.setCurrentServer(serverConfigService.activeServer!.id);

      getIt.resetLazySingleton<JwtHttpClient>();
    }
  });
}

Future<void> _registerRepositories() async {
  // Server repository first
  getIt.registerLazySingleton<ServerRepository>(
    () => ServerRepository(userPreferences: getIt<UserPreferences>()),
  );

  // Initialize server repository
  final serverRepo = getIt<ServerRepository>();
  await serverRepo.initialize();

  final baseUrl = serverRepo.activeServer?.url ?? '';

  // API clients
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(baseUrl: baseUrl));
  getIt.registerLazySingleton<ChatApi>(() => ChatApi(baseUrl: baseUrl));
  getIt.registerLazySingleton<GameApi>(() => GameApi(baseUrl: baseUrl));

  getIt.registerLazySingleton<GameRestDataSource>(
    () => GameRestDataSource(gameApi: getIt<GameApi>()),
  );

  getIt.registerLazySingleton<GameWebSocketDataSource>(
    () => GameWebSocketDataSource(webSocketClient: getIt<WebSocketClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      authApi: getIt<AuthApi>(),
      secureStorage: getIt<SecureStorage>(),
      userPreferences: getIt<UserPreferences>(),
    ),
  );

  getIt.registerLazySingleton<WebSocketClient>(
    () => WebSocketClient(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<WebSocketRepository>(
    () => WebSocketRepository(websocketClient: getIt<WebSocketClient>()),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepository(
      chatApi: getIt<ChatApi>(),
      websocketRepository: getIt<WebSocketRepository>(),
    ),
  );

  getIt.registerLazySingleton<GameRepository>(
    () => GameRepository(
      restDataSource: getIt<GameRestDataSource>(),
      webSocketDataSource: getIt<GameWebSocketDataSource>(),
      webSocketManager: getIt<WebSocketManager>(),
      userContextProvider: getIt<UserContextProvider>(),
    ),
  );
}

Future<void> _registerBlocs() async {
  getIt.registerLazySingleton<AppBloc>(
    () => AppBloc(connectionChecker: getIt<InternetConnectionChecker>()),
  );

  getIt.registerLazySingleton<PlatformBloc>(
    () => PlatformBloc()..add(const PlatformInitialized()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RouterBloc>(() => RouterBloc());

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<ServerSelectionBloc>(
    () => ServerSelectionBloc(
      serverRepository: getIt<ServerRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<ServerConfigBloc>(
    () => ServerConfigBloc(serverRepository: getIt<ServerRepository>()),
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

  getIt.registerFactory<ConnectionBloc>(
    () => ConnectionBloc(websocketRepository: getIt<WebSocketRepository>()),
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
  // Close and unregister services that need to be reset
  if (getIt.isRegistered<JwtHttpClient>()) {
    getIt.resetLazySingleton<JwtHttpClient>();
  }

  if (getIt.isRegistered<WebSocketManager>()) {
    final wsManager = getIt<WebSocketManager>();
    wsManager.disconnect();
  }

  if (getIt.isRegistered<GameService>()) {
    getIt.resetLazySingleton<GameService>();
  }

  if (getIt.isRegistered<ChatService>()) {
    getIt.resetLazySingleton<ChatService>();
  }

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
