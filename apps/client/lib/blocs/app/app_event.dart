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
