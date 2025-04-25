import 'dart:async';

import '../../data/api/chat_api.dart';
import '../../models/chat_message.dart';
import '../../repositories/websocket/websocket_repository.dart';

class ChatRepository {
  final ChatApi _chatApi;
  final WebSocketRepository _websocketRepository;
  final _messagesController = StreamController<ChatMessage>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  StreamSubscription? _wsConnectionSubscription;

  ChatRepository({
    required ChatApi chatApi,
    required WebSocketRepository websocketRepository,
  }) : _chatApi = chatApi,
       _websocketRepository = websocketRepository {
    _init();
  }

  void _init() {
    // Subscribe to chat messages and typing indicators
    _websocketRepository.subscribeToChatMessages(_handleChatMessage);
    _websocketRepository.subscribeToTypingIndicators(_handleTypingIndicator);

    // Monitor connection status
    _wsConnectionSubscription = _websocketRepository.connectionStatus.listen(
      (isConnected) => _connectionStatusController.add(isConnected),
    );
  }

  void _handleChatMessage(ChatMessage message) {
    _messagesController.add(message);
  }

  void _handleTypingIndicator(Map<String, dynamic> status) {
    _typingController.add(status);
  }

  Future<List<ChatMessage>> getChatHistory(
    String roomId, [
    int limit = 50,
  ]) async {
    try {
      if (_websocketRepository.isConnected) {
        return await _websocketRepository.getChatHistory(roomId, limit: limit);
      } else {
        return await _chatApi.getChatHistory(roomId, limit);
      }
    } catch (e) {
      // Fallback to REST if WebSocket fails
      if (_websocketRepository.isConnected) {
        return await _chatApi.getChatHistory(roomId, limit);
      }
      rethrow;
    }
  }

  Future<void> joinRoom(String roomId) async {
    try {
      if (_websocketRepository.isConnected) {
        await _websocketRepository.joinChatRoom(roomId);
      } else {
        await _chatApi.joinRoom(roomId);
      }
    } catch (e) {
      // Fallback to REST if WebSocket fails
      if (_websocketRepository.isConnected) {
        await _chatApi.joinRoom(roomId);
      }
      rethrow;
    }
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      if (_websocketRepository.isConnected) {
        await _websocketRepository.leaveChatRoom(roomId);
      } else {
        await _chatApi.leaveRoom(roomId);
      }
    } catch (e) {
      // Fallback to REST if WebSocket fails
      if (_websocketRepository.isConnected) {
        await _chatApi.leaveRoom(roomId);
      }
      rethrow;
    }
  }

  Future<void> sendMessage(String content, String roomId) async {
    try {
      if (_websocketRepository.isConnected) {
        await _websocketRepository.sendChatMessage(content, roomId);
      } else {
        await _chatApi.sendMessage(content, roomId);
      }
    } catch (e) {
      // Fallback to REST if WebSocket fails
      if (_websocketRepository.isConnected) {
        await _chatApi.sendMessage(content, roomId);
      }
      rethrow;
    }
  }

  void sendTypingIndicator(String roomId, bool isTyping) {
    if (_websocketRepository.isConnected) {
      _websocketRepository.sendTypingIndicator(roomId, isTyping);
    }
  }

  Future<String> createRoom(
    String name,
    String? description,
    String type,
  ) async {
    try {
      if (_websocketRepository.isConnected) {
        final response = await _websocketRepository.client
            .sendRequest<Map<String, dynamic>>('createChatRoom', {
              'name': name,
              'description': description,
              'type': type,
            });
        return response['id'];
      } else {
        final room = await _chatApi.createRoom(name, description, type);
        return room.id;
      }
    } catch (e) {
      // Fallback to REST if WebSocket fails
      if (_websocketRepository.isConnected) {
        final room = await _chatApi.createRoom(name, description, type);
        return room.id;
      }
      rethrow;
    }
  }

  Stream<ChatMessage> get messages => _messagesController.stream;
  Stream<Map<String, dynamic>> get typingStatus => _typingController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool get isUsingWebSocket => _websocketRepository.isConnected;

  void dispose() {
    _websocketRepository.unsubscribeFromChatMessages(
      (dynamic message) => _handleChatMessage(message as ChatMessage),
    );
    _websocketRepository.unsubscribeFromTypingIndicators(
      (dynamic status) =>
          _handleTypingIndicator(status as Map<String, dynamic>),
    );
    _wsConnectionSubscription?.cancel();
    _messagesController.close();
    _typingController.close();
    _connectionStatusController.close();
  }
}
