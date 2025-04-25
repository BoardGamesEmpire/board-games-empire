import 'dart:async';

import '../../data/websocket/websocket_client.dart';
import '../../models/chat_message.dart';
import '../../models/config/server_config.dart';
import '../../models/search_result.dart';
import '../../models/game/game.dart';

class WebSocketRepository {
  final WebSocketClient _websocketClient;
  final StreamController<ServerConfig> _serverChangedController =
      StreamController<ServerConfig>.broadcast();

  WebSocketRepository({required WebSocketClient websocketClient})
    : _websocketClient = websocketClient;

  WebSocketClient get client => _websocketClient;

  Future<bool> connect(String url, String serverId) async {
    return await _websocketClient.connect(url, serverId);
  }

  void disconnect() {
    _websocketClient.disconnect();
  }

  void notifyServerChanged(ServerConfig serverConfig) {
    _serverChangedController.add(serverConfig);
  }

  // General WebSocket Methods
  Stream<bool> get connectionStatus => _websocketClient.statusStream;
  bool get isConnected => _websocketClient.isConnected;
  String? get currentServerId => _websocketClient.currentServerId;

  // Game-related methods
  Future<SearchResult> searchGames(String query, String externalSource) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _websocketClient.sendRequest<Map<String, dynamic>>(
        'searchGames',
        {'query': query, 'externalSource': externalSource},
        timeout: const Duration(seconds: 30),
      );

      return SearchResult.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _websocketClient.sendRequest<Map<String, dynamic>>(
        'getGameDetails',
        {
          'gameId': gameId,
          'isExternal': isExternal,
          'externalSource': externalSource,
        },
        timeout: const Duration(seconds: 20),
      );

      return Game.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Game> addGame(Game game) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _websocketClient.sendRequest<Map<String, dynamic>>(
        'addGame',
        game.toJson(),
        timeout: const Duration(seconds: 20),
      );

      return Game.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  void subscribeToGameResults(Function(SearchResult) callback) {
    _websocketClient.subscribe('searchResults', (dynamic data) {
      final searchResult = SearchResult.fromJson(data);
      callback(searchResult);
    });
  }

  void unsubscribeFromGameResults(Function(dynamic) callback) {
    _websocketClient.unsubscribe('searchResults', callback);
  }

  // Chat-related methods
  Future<List<ChatMessage>> getChatHistory(
    String roomId, {
    int limit = 50,
  }) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _websocketClient.sendRequest<List<dynamic>>(
        'getChatHistory',
        {'roomId': roomId, 'limit': limit},
        timeout: const Duration(seconds: 15),
      );

      return result
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinChatRoom(String roomId) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      await _websocketClient.sendRequest<void>('joinChatRoom', {
        'roomId': roomId,
      }, timeout: const Duration(seconds: 10));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leaveChatRoom(String roomId) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      await _websocketClient.sendRequest<void>('leaveChatRoom', {
        'roomId': roomId,
      }, timeout: const Duration(seconds: 10));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendChatMessage(String content, String roomId) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      await _websocketClient.sendRequest<void>('sendChatMessage', {
        'content': content,
        'roomId': roomId,
      }, timeout: const Duration(seconds: 10));
    } catch (e) {
      rethrow;
    }
  }

  void subscribeToChatMessages(Function(ChatMessage) callback) {
    _websocketClient.subscribe('chatMessage', (dynamic data) {
      final message = ChatMessage.fromJson(data);
      callback(message);
    });
  }

  void unsubscribeFromChatMessages(Function(dynamic) callback) {
    _websocketClient.unsubscribe('chatMessage', callback);
  }

  void sendTypingIndicator(String roomId, bool isTyping) {
    if (!_websocketClient.isConnected) return;

    _websocketClient.send({
      'type': 'userTyping',
      'payload': {'roomId': roomId, 'isTyping': isTyping},
    });
  }

  void subscribeToTypingIndicators(Function(Map<String, dynamic>) callback) {
    _websocketClient.subscribe('userTyping', (dynamic data) {
      callback(data);
    });
  }

  void unsubscribeFromTypingIndicators(Function(dynamic) callback) {
    _websocketClient.unsubscribe('userTyping', callback);
  }

  Future<List<dynamic>> getUserCollection(String userId) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _websocketClient.sendRequest<List<dynamic>>(
        'getUserCollection',
        {'userId': userId},
        timeout: const Duration(seconds: 20),
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addGameToCollection(String gameId, int quantity) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      await _websocketClient.sendRequest<void>('addGameToCollection', {
        'gameId': gameId,
        'quantity': quantity,
      }, timeout: const Duration(seconds: 10));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeGameFromCollection(String gameId) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      await _websocketClient.sendRequest<void>('removeGameFromCollection', {
        'gameId': gameId,
      }, timeout: const Duration(seconds: 10));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGameInCollection(
    String gameId, {
    int? quantity,
    int? rating,
    String? comment,
    bool? favorite,
  }) async {
    if (!_websocketClient.isConnected) {
      throw Exception('WebSocket not connected');
    }

    final Map<String, dynamic> updateData = {
      'gameId': gameId,
      if (quantity != null) 'quantity': quantity,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (favorite != null) 'favorite': favorite,
    };

    try {
      await _websocketClient.sendRequest<void>(
        'updateGameInCollection',
        updateData,
        timeout: const Duration(seconds: 10),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Server monitoring
  Stream<ServerConfig> get serverChanges => _serverChangedController.stream;

  void dispose() {
    _serverChangedController.close();
  }
}
