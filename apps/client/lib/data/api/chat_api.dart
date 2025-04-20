import '../../models/chat_message.dart';
import './api_exception.dart';
import './base_api.dart';

class ChatRoom {
  final String id;
  final String name;
  final String? description;
  final String type;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ChatApi extends BaseApi {
  ChatApi({required super.baseUrl});

  final apiPrefix = '/chat';

  Future<List<ChatMessage>> getChatHistory(String roomId, int limit) async {
    try {
      final response = await get(
        '$apiPrefix/rooms/$roomId/history?limit=$limit',
      );

      if (response is List) {
        return response.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw ApiException(message: 'Invalid response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to get chat history: ${e.toString()}',
      );
    }
  }

  Future<void> joinRoom(String roomId) async {
    try {
      await post('$apiPrefix/rooms/$roomId/join', body: <String, String>{});
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to join room: ${e.toString()}');
    }
  }

  Future<void> leaveRoom(String roomId) async {
    try {
      await post('$apiPrefix/rooms/$roomId/leave', body: <String, String>{});
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to leave room: ${e.toString()}');
    }
  }

  Future<void> sendMessage(String content, String roomId) async {
    try {
      await post(
        '$apiPrefix/messages',
        body: {
          'content': content,
          'roomId': roomId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to send message: ${e.toString()}');
    }
  }

  Future<ChatRoom> createRoom(
    String name,
    String? description,
    String type,
  ) async {
    try {
      final response = await post(
        '$apiPrefix/rooms',
        body: {'name': name, 'description': description, 'type': type},
      );

      return ChatRoom.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to create room: ${e.toString()}');
    }
  }

  Future<List<ChatRoom>> getRooms() async {
    try {
      final response = await get('$apiPrefix/rooms');

      if (response is List) {
        return response.map((json) => ChatRoom.fromJson(json)).toList();
      } else {
        throw ApiException(message: 'Invalid response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to get rooms: ${e.toString()}');
    }
  }
}
