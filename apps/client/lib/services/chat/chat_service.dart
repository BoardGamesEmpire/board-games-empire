import 'dart:async';
import 'dart:convert';
import '../websocket/websocket_manager.dart';
import '../server_config_service.dart';
import '../jwt_interceptor.dart';
import '../../di/injection.dart';
import '../../models/chat_message.dart';

class ChatService {
  late final WebSocketManager _socketManager;
  late final ServerConfigService _serverConfigService;
  late final JwtHttpClient _httpClient;

  final _messageController = StreamController<ChatMessage>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  bool _useWebSocket = true;

  ChatService({
    WebSocketManager? socketManager,
    ServerConfigService? serverConfigService,
    JwtHttpClient? httpClient,
  }) {
    _socketManager = socketManager ?? getIt<WebSocketManager>();
    _serverConfigService = serverConfigService ?? getIt<ServerConfigService>();
    _httpClient = httpClient ?? getIt<JwtHttpClient>();

    _initService();
  }

  void _initService() {
    _socketManager.subscribe('chatMessage', _handleChatMessage);

    _socketManager.subscribe('userTyping', _handleUserTyping);

    _socketManager.statusStream.listen((connected) {
      _useWebSocket = connected;
    });
  }

  void _handleChatMessage(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final message = ChatMessage.fromJson(payload);
      _messageController.add(message);
    }
  }

  void _handleUserTyping(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      _typingController.add(payload);
    }
  }

  Future<void> sendMessage(String content, {String? roomId}) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    final payload = {
      'content': content,
      'roomId': roomId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      if (_useWebSocket) {
        await _socketManager.sendRequest<void>(
          'sendMessage',
          payload,
          timeout: const Duration(seconds: 10),
        );
      } else {
        await _httpClient.post(
          Uri.parse('/chat/messages'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        return sendMessage(content, roomId: roomId);
      }
      rethrow;
    }
  }

  Future<void> joinRoom(String roomId) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    try {
      if (_useWebSocket) {
        await _socketManager.sendRequest<void>('joinRoom', {
          'roomId': roomId,
        }, timeout: const Duration(seconds: 10));
      } else {
        await _httpClient.post(
          Uri.parse('/chat/rooms/$roomId/join'),
          headers: {'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        return joinRoom(roomId);
      }

      rethrow;
    }
  }

  Future<void> leaveRoom(String roomId) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    try {
      if (_useWebSocket) {
        await _socketManager.sendRequest<void>('leaveRoom', {
          'roomId': roomId,
        }, timeout: const Duration(seconds: 10));
      } else {
        await _httpClient.post(
          Uri.parse('/chat/rooms/$roomId/leave'),
          headers: {'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        return leaveRoom(roomId);
      }

      rethrow;
    }
  }

  void sendTypingIndicator(String roomId, bool isTyping) {
    if (_serverConfigService.activeServer == null || !_useWebSocket) {
      return;
    }

    _socketManager.send({
      'type': 'userTyping',
      'payload': {'roomId': roomId, 'isTyping': isTyping},
    });
  }

  Future<List<ChatMessage>> getChatHistory(
    String roomId, {
    int limit = 50,
  }) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    try {
      if (_useWebSocket) {
        final result = await _socketManager.sendRequest<List<dynamic>>(
          'getChatHistory',
          {'roomId': roomId, 'limit': limit},
          timeout: const Duration(seconds: 15),
        );

        return result
            .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final response = await _httpClient.get(
          Uri.parse('/chat/rooms/$roomId/history?limit=$limit'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data
              .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Failed to get chat history: ${response.body}');
        }
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        return getChatHistory(roomId, limit: limit);
      }
      rethrow;
    }
  }

  Stream<ChatMessage> get messageStream => _messageController.stream;

  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;

  bool get isUsingWebSocket => _useWebSocket;

  void dispose() {
    _socketManager.unsubscribe('chatMessage', _handleChatMessage);
    _socketManager.unsubscribe('userTyping', _handleUserTyping);
    _messageController.close();
    _typingController.close();
  }
}
