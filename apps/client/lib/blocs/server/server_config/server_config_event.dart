part of 'server_config_bloc.dart';

abstract class ServerConfigEvent extends Equatable {
  const ServerConfigEvent();

  @override
  List<Object?> get props => [];
}

class ServerConfigInitialized extends ServerConfigEvent {
  final bool isInitialSetup;

  const ServerConfigInitialized({this.isInitialSetup = false});

  @override
  List<Object> get props => [isInitialSetup];
}

class ServerConfigNameChanged extends ServerConfigEvent {
  final String name;

  const ServerConfigNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class ServerConfigUrlChanged extends ServerConfigEvent {
  final String url;

  const ServerConfigUrlChanged(this.url);

  @override
  List<Object> get props => [url];
}

class ServerConfigValidationRequested extends ServerConfigEvent {
  const ServerConfigValidationRequested();
}

class ServerConfigValidationCompleted extends ServerConfigEvent {
  final bool isValid;

  const ServerConfigValidationCompleted(this.isValid);

  @override
  List<Object> get props => [isValid];
}

class ServerConfigAddRequested extends ServerConfigEvent {
  const ServerConfigAddRequested();
}
