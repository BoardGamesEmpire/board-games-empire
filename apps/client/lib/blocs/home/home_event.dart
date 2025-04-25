part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialized extends HomeEvent {
  const HomeInitialized();
}

class HomeWebSocketConnectRequested extends HomeEvent {
  const HomeWebSocketConnectRequested();
}

class HomeWebSocketStatusChanged extends HomeEvent {
  final bool isConnected;

  const HomeWebSocketStatusChanged(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class HomeLogoutRequested extends HomeEvent {
  const HomeLogoutRequested();
}

class HomeLogoutConfirmed extends HomeEvent {
  final bool allSessions;

  const HomeLogoutConfirmed({this.allSessions = false});

  @override
  List<Object> get props => [allSessions];
}

class HomeLogoutCancelled extends HomeEvent {
  const HomeLogoutCancelled();
}

class HomeServerConfigChanged extends HomeEvent {
  final ServerConfig? activeServer;

  const HomeServerConfigChanged(this.activeServer);

  @override
  List<Object?> get props => [activeServer];
}
