part of 'server_config_bloc.dart';

abstract class ServerConfigEvent extends Equatable {
  const ServerConfigEvent();

  @override
  List<Object?> get props => [];
}

class ServerConfigInitialized extends ServerConfigEvent {
  const ServerConfigInitialized();
}

class ServerConfigLoadRequested extends ServerConfigEvent {
  const ServerConfigLoadRequested();
}

class ServerConfigAdded extends ServerConfigEvent {
  final String name;
  final String url;

  const ServerConfigAdded({required this.name, required this.url});

  @override
  List<Object> get props => [name, url];
}

class ServerConfigUpdated extends ServerConfigEvent {
  final String serverId;
  final String? name;
  final String? url;

  const ServerConfigUpdated({required this.serverId, this.name, this.url});

  @override
  List<Object?> get props => [serverId, name, url];
}

class ServerConfigRemoved extends ServerConfigEvent {
  final String serverId;

  const ServerConfigRemoved(this.serverId);

  @override
  List<Object> get props => [serverId];
}

class ServerConfigActiveChanged extends ServerConfigEvent {
  final String serverId;

  const ServerConfigActiveChanged(this.serverId);

  @override
  List<Object> get props => [serverId];
}

class ServerConfigValidationRequested extends ServerConfigEvent {
  final String url;

  const ServerConfigValidationRequested(this.url);

  @override
  List<Object> get props => [url];
}

class ServerValidated extends ServerConfigEvent {
  final String url;
  final bool isValid;

  const ServerValidated({required this.url, required this.isValid});

  @override
  List<Object> get props => [url, isValid];
}

class ServerConfigError extends ServerConfigEvent {
  final String error;

  const ServerConfigError(this.error);

  @override
  List<Object> get props => [error];
}

class ServerConfigErrorCleared extends ServerConfigEvent {
  const ServerConfigErrorCleared();
}
