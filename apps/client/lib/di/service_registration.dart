import 'package:get_it/get_it.dart';
import '../services/game/game_service.dart';
import '../services/websocket/websocket_manager.dart';
import '../services/chat/chat_service.dart';

/// Register all app-specific services with GetIt
void registerAppServices(GetIt getIt) {
  if (!getIt.isRegistered<WebSocketManager>()) {
    getIt.registerLazySingleton<WebSocketManager>(() => WebSocketManager());
  }

  getIt.registerLazySingleton<GameService>(() => GameService());
  getIt.registerLazySingleton<ChatService>(() => ChatService());
}
