part of 'app_initialization_bloc.dart';

abstract class AppInitializationEvent extends Equatable {
  const AppInitializationEvent();

  @override
  List<Object?> get props => [];
}

class AppInitStarted extends AppInitializationEvent {
  const AppInitStarted();
}

class ServerDataLoaded extends AppInitializationEvent {
  const ServerDataLoaded();
}

class AuthDataLoaded extends AppInitializationEvent {
  const AuthDataLoaded();
}

class ThemeLoaded extends AppInitializationEvent {
  const ThemeLoaded();
}

class AppInitializationCompleted extends AppInitializationEvent {
  const AppInitializationCompleted();
}

class AppInitializationFailed extends AppInitializationEvent {
  final String error;

  const AppInitializationFailed(this.error);

  @override
  List<Object> get props => [error];
}

class AppInitializationHandoffToAppBloc extends AppInitializationEvent {
  const AppInitializationHandoffToAppBloc();
}
