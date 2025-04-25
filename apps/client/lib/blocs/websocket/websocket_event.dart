part of 'websocket_bloc.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object?> get props => [];
}

class WebSocketConnectRequested extends WebSocketEvent {
  final ServerConfig server;

  const WebSocketConnectRequested(this.server);

  @override
  List<Object> get props => [server];
}

class WebSocketDisconnectRequested extends WebSocketEvent {
  const WebSocketDisconnectRequested();
}

class WebSocketStatusChanged extends WebSocketEvent {
  final bool isConnected;

  const WebSocketStatusChanged(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class WebSocketMessageReceived extends WebSocketEvent {
  final Map<String, dynamic> message;

  const WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class WebSocketReconnectAttempt extends WebSocketEvent {
  const WebSocketReconnectAttempt();
}

class WebSocketServerChanged extends WebSocketEvent {
  final ServerConfig server;

  const WebSocketServerChanged(this.server);

  @override
  List<Object> get props => [server];
}

class WebSocketAutoReconnectChanged extends WebSocketEvent {
  final bool enabled;

  const WebSocketAutoReconnectChanged(this.enabled);

  @override
  List<Object> get props => [enabled];
}
