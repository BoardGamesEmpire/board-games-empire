part of 'connection_bloc.dart';

enum ConnectionStatus { disconnected, connecting, connected, error }

class ConnectionState extends Equatable {
  const ConnectionState({
    this.status = ConnectionStatus.disconnected,
    this.server,
    this.serverId,
    this.error,
  });

  const ConnectionState.disconnected({this.server, this.serverId})
    : status = ConnectionStatus.disconnected,
      error = null;

  const ConnectionState.connecting({required this.server, this.serverId})
    : status = ConnectionStatus.connecting,
      error = null;

  const ConnectionState.connected({
    required this.server,
    required this.serverId,
  }) : status = ConnectionStatus.connected,
       error = null;

  ConnectionState.error(this.error, this.server)
    : status = ConnectionStatus.error,
      serverId = server?.id;

  final ConnectionStatus status;
  final ServerConfig? server;
  final String? serverId;
  final String? error;

  bool get isConnected => status == ConnectionStatus.connected;

  ConnectionState copyWith({
    ConnectionStatus? status,
    ServerConfig? server,
    String? serverId,
    String? error,
  }) {
    return ConnectionState(
      status: status ?? this.status,
      server: server ?? this.server,
      serverId: serverId ?? this.serverId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, server, serverId, error];
}
