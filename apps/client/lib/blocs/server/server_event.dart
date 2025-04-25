part of 'server_bloc.dart';

abstract class ServerEvent extends Equatable {
  const ServerEvent();

  @override
  List<Object?> get props => [];
}

class ServerInitializeRequested extends ServerEvent {
  const ServerInitializeRequested();
}

class ServerInitializationCompleted extends ServerEvent {
  const ServerInitializationCompleted();
}

class ServerListUpdated extends ServerEvent {
  final List<ServerConfig> servers;

  const ServerListUpdated(this.servers);

  @override
  List<Object> get props => [servers];
}

class ServerActiveUpdated extends ServerEvent {
  final ServerConfig? server;

  const ServerActiveUpdated(this.server);

  @override
  List<Object?> get props => [server];
}

class ServerAddRequested extends ServerEvent {
  const ServerAddRequested({required this.name, required this.url});

  final String name;
  final String url;

  @override
  List<Object> get props => [name, url];
}

class ServerUpdateRequested extends ServerEvent {
  const ServerUpdateRequested({required this.serverId, this.name, this.url});

  final String serverId;
  final String? name;
  final String? url;

  @override
  List<Object?> get props => [serverId, name, url];
}

class ServerRemoveRequested extends ServerEvent {
  const ServerRemoveRequested(this.serverId);

  final String serverId;

  @override
  List<Object> get props => [serverId];
}

class ServerActiveChanged extends ServerEvent {
  const ServerActiveChanged(this.serverId);

  final String serverId;

  @override
  List<Object> get props => [serverId];
}

class ServerConnectionTest extends ServerEvent {
  const ServerConnectionTest(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}
