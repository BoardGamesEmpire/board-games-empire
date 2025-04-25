part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {
  const AppStarted();
}

class ThemeChanged extends AppEvent {
  const ThemeChanged(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

class InternetConnectionChanged extends AppEvent {
  const InternetConnectionChanged(this.hasConnection);

  final bool hasConnection;

  @override
  List<Object> get props => [hasConnection];
}

class AppError extends AppEvent {
  const AppError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AppErrorDismissed extends AppEvent {
  const AppErrorDismissed();
}

class AppInitialized extends AppEvent {
  final bool hasServers;
  final bool isAuthenticated;
  final ServerConfig? activeServer;

  const AppInitialized({
    required this.hasServers,
    required this.isAuthenticated,
    this.activeServer,
  });

  @override
  List<Object?> get props => [hasServers, isAuthenticated, activeServer];
}

class AppRequestedInitialization extends AppEvent {
  const AppRequestedInitialization();
}

class AppConnectionRequested extends AppEvent {
  const AppConnectionRequested();
}

class AppConnectionStatusChanged extends AppEvent {
  final bool isConnected;

  const AppConnectionStatusChanged(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}
