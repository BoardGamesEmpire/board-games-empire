part of 'app_bloc.dart';

enum AppStatus { initial, initializing, initialized, error }

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.initial,
    this.themeMode = ThemeMode.system,
    this.hasInternetConnection = true,
    this.errorMessage,
  });

  final AppStatus status;
  final ThemeMode themeMode;
  final bool hasInternetConnection;
  final String? errorMessage;

  AppState copyWith({
    AppStatus? status,
    ThemeMode? themeMode,
    bool? hasInternetConnection,
    String? errorMessage,
  }) {
    return AppState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      hasInternetConnection:
          hasInternetConnection ?? this.hasInternetConnection,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    themeMode,
    hasInternetConnection,
    errorMessage,
  ];
}
