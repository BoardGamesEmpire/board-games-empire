part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionRequested extends ConnectionEvent {
  const ConnectionRequested(this.server);

  final ServerConfig server;

  @override
  List<Object> get props => [server];
}

class ConnectionDisconnectRequested extends ConnectionEvent {
  const ConnectionDisconnectRequested();
}

class ConnectionStatusChanged extends ConnectionEvent {
  const ConnectionStatusChanged(this.isConnected);

  final bool isConnected;

  @override
  List<Object> get props => [isConnected];
}

class ConnectionServerChanged extends ConnectionEvent {
  const ConnectionServerChanged(this.server);

  final ServerConfig server;

  @override
  List<Object> get props => [server];
}
