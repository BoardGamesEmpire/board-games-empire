import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../repositories/auth/auth_repository.dart';

typedef MessageHandler = void Function(dynamic data);

class WebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final AuthRepository _authRepository;

  WebSocketClient({required AuthRepository authRepository})
    : _authRepository = authRepository;

  bool _isConnected = false;

  final _statusController = StreamController<bool>.broadcast();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final Map<String, Completer<dynamic>> _requestHandlers = {};
  final Map<String, List<MessageHandler>> _messageTypeHandlers = {};

  String? _currentServerId;

  Future<bool> connect(
    String url,
    String serverId, {
    Map<String, String>? headers,
  }) async {
    if (_isConnected && _currentServerId == serverId) {
      return true;
    }

    if (_isConnected) {
      disconnect();
    }

    try {
      final baseUrl = Uri.parse(url);
      final path = baseUrl.path;
      final pathless = url.replaceRange(url.indexOf(path), url.length, '');

      var wsUrl = pathless.replaceFirst(RegExp(r'^http'), 'ws');
      wsUrl += '/socket';

      headers = _addAuthHeaders(headers);

      final authHeader = headers['Authorization'];
      if (authHeader != null) {
        wsUrl +=
            '?authorization=${Uri.encodeComponent(authHeader.split(' ').last)}';
      }

      if (kDebugMode) {
        print('Connecting to WebSocket: $wsUrl');
      }

      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['json'],
      );

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onDone: _handleDisconnection,
        onError: _handleError,
      );

      _isConnected = true;
      _currentServerId = serverId;
      _statusController.add(true);

      if (kDebugMode) {
        print('WebSocket connected to server: $serverId');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('WebSocket connection failed: $e');
      }

      _isConnected = false;
      _currentServerId = null;
      _statusController.add(false);

      return false;
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _handleDisconnection();
  }

  void _handleDisconnection() {
    if (!_isConnected) return;

    _isConnected = false;
    _statusController.add(false);

    for (final completer in _requestHandlers.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('WebSocket disconnected'));
      }
    }
    _requestHandlers.clear();

    if (kDebugMode) {
      print('WebSocket disconnected');
    }
  }

  void _handleError(dynamic error) {
    if (kDebugMode) {
      print('WebSocket error: $error');
      if (error is WebSocketChannelException) {
        if (error.inner != null) {
          final err = error.inner as dynamic;
          print('Websocket inner error: ${err.message.toString()}');
        }

        print('Websocket error: ${error.message}');
      }
    }
    _handleDisconnection();
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);

      if (data is! Map<String, dynamic>) {
        if (kDebugMode) {
          print('Invalid WebSocket message format: $message');
        }
        return;
      }

      _messageController.add(data);

      if (data['requestId'] != null) {
        final requestId = data['requestId'];
        if (_requestHandlers.containsKey(requestId)) {
          final completer = _requestHandlers.remove(requestId)!;
          if (!completer.isCompleted) {
            if (data['error'] != null) {
              completer.completeError(Exception(data['error']));
            } else {
              completer.complete(data['payload']);
            }
          }
        }
      }

      if (data['type'] != null) {
        final type = data['type'];
        if (_messageTypeHandlers.containsKey(type)) {
          for (final handler in _messageTypeHandlers[type]!) {
            handler(data['payload']);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing WebSocket message: $e');
      }
    }
  }

  Map<String, String> _addAuthHeaders(Map<String, String>? headers) {
    headers ??= {};

    if (_authRepository.accessToken != null) {
      headers['Authorization'] = 'Bearer ${_authRepository.accessToken}';
    }

    return headers;
  }

  void send(Map<String, dynamic> message) {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }

    _channel!.sink.add(jsonEncode(message));
  }

  Future<T> sendRequest<T>(
    String type,
    Map<String, dynamic> payload, {
    Duration? timeout,
  }) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }

    final requestId =
        '${type}_${DateTime.now().millisecondsSinceEpoch}_${_requestHandlers.length}';
    final completer = Completer<T>();

    _requestHandlers[requestId] = completer;

    send({'type': type, 'requestId': requestId, 'payload': payload});

    if (timeout != null) {
      Timer(timeout, () {
        if (_requestHandlers.containsKey(requestId)) {
          _requestHandlers.remove(requestId);
          if (!completer.isCompleted) {
            completer.completeError(
              TimeoutException('Request timed out: $type'),
            );
          }
        }
      });
    }

    return completer.future;
  }

  void subscribe(String type, MessageHandler handler) {
    if (!_messageTypeHandlers.containsKey(type)) {
      _messageTypeHandlers[type] = [];
    }
    _messageTypeHandlers[type]!.add(handler);
  }

  void unsubscribe(String type, MessageHandler handler) {
    if (_messageTypeHandlers.containsKey(type)) {
      _messageTypeHandlers[type]!.remove(handler);
      if (_messageTypeHandlers[type]!.isEmpty) {
        _messageTypeHandlers.remove(type);
      }
    }
  }

  // Getters
  Stream<bool> get statusStream => _statusController.stream;
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _isConnected;
  String? get currentServerId => _currentServerId;

  void dispose() {
    disconnect();
    _subscription?.cancel();
    _statusController.close();
    _messageController.close();
  }
}
