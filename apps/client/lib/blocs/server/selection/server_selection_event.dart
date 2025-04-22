part of 'server_selection_bloc.dart';

abstract class ServerSelectionEvent extends Equatable {
  const ServerSelectionEvent();

  @override
  List<Object?> get props => [];
}

class ServerSelectionInitialized extends ServerSelectionEvent {
  const ServerSelectionInitialized();
}

class ServerSelectionRefreshRequested extends ServerSelectionEvent {
  const ServerSelectionRefreshRequested();
}

class ServerSelected extends ServerSelectionEvent {
  final String serverId;

  const ServerSelected(this.serverId);

  @override
  List<Object> get props => [serverId];
}

class ServerAddRequested extends ServerSelectionEvent {
  const ServerAddRequested();
}

class ServerAddCompleted extends ServerSelectionEvent {
  final ServerConfig? server;

  const ServerAddCompleted({this.server});

  @override
  List<Object?> get props => [server];
}

class ServerRemovalRequested extends ServerSelectionEvent {
  final ServerConfig server;

  const ServerRemovalRequested(this.server);

  @override
  List<Object> get props => [server];
}

class ServerRemovalConfirmed extends ServerSelectionEvent {
  const ServerRemovalConfirmed();
}

class ServerRemovalCancelled extends ServerSelectionEvent {
  const ServerRemovalCancelled();
}
