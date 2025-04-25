part of 'websocket_bloc.dart';

enum WebSocketStatus { disconnected, connecting, connected, failed }

class WebSocketState extends Equatable {
  final WebSocketStatus status;
  final ServerConfig? server;
  final String? error;
  final Map<String, dynamic>? lastMessage;
  final bool autoReconnect;
  final bool autoConnect;
  final int reconnectAttempt;

  const WebSocketState({
    this.status = WebSocketStatus.disconnected,
    this.server,
    this.error,
    this.lastMessage,
    this.autoReconnect = true,
    this.autoConnect = true,
    this.reconnectAttempt = 0,
  });

  WebSocketState copyWith({
    WebSocketStatus? status,
    ServerConfig? server,
    String? error,
    Map<String, dynamic>? lastMessage,
    bool? autoReconnect,
    bool? autoConnect,
    int? reconnectAttempt,
  }) {
    return WebSocketState(
      status: status ?? this.status,
      server: server ?? this.server,
      error: error,
      lastMessage: lastMessage ?? this.lastMessage,
      autoReconnect: autoReconnect ?? this.autoReconnect,
      autoConnect: autoConnect ?? this.autoConnect,
      reconnectAttempt: reconnectAttempt ?? this.reconnectAttempt,
    );
  }

  bool get isConnected => status == WebSocketStatus.connected;
  bool get isConnecting => status == WebSocketStatus.connecting;
  bool get isDisconnected =>
      status == WebSocketStatus.disconnected ||
      status == WebSocketStatus.failed;

  @override
  List<Object?> get props => [
    status,
    server,
    error,
    lastMessage,
    autoReconnect,
    autoConnect,
    reconnectAttempt,
  ];
}
