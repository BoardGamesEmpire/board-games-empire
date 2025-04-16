// lib/di/injection.dart - Updated
import 'package:get_it/get_it.dart';
import '../services/server_config_service.dart';
import '../services/auth_service.dart';
import '../services/websocket/websocket_manager.dart';
import '../services/jwt_interceptor.dart';
import 'service_registration.dart';
import '../services/game/game_service.dart';

final GetIt getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupDependencyInjection() async {
  await _registerCoreServices();

  registerAppServices(getIt);

  await _initializeServices();

  _setupServiceDependencies();
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

void resetAppServices() {
  if (getIt.isRegistered<JwtHttpClient>()) {
    getIt.resetLazySingleton<JwtHttpClient>();
  }

  final wsManager = getIt<WebSocketManager>();
  wsManager.disconnect();

  if (getIt.isRegistered<GameService>()) {
    getIt.resetLazySingleton<GameService>();
  }
}
