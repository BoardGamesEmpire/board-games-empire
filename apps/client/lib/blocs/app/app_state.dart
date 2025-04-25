part of 'app_bloc.dart';

enum AppStatus {
  initial,
  initializing,
  needsServerSetup,
  unauthenticated,
  authenticated,
  error,
}

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.initial,
    this.themeMode = ThemeMode.system,
    this.hasInternetConnection = true,
    this.isWebSocketConnected = false,
    this.errorMessage,
    this.isInitialized = false,
    this.activeServer,
  });

  final AppStatus status;
  final ThemeMode themeMode;
  final bool hasInternetConnection;
  final bool isWebSocketConnected;
  final String? errorMessage;
  final bool isInitialized;
  final ServerConfig? activeServer;

  AppState copyWith({
    AppStatus? status,
    ThemeMode? themeMode,
    bool? hasInternetConnection,
    bool? isWebSocketConnected,
    String? errorMessage,
    bool? isInitialized,
    ServerConfig? activeServer,
  }) {
    return AppState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      hasInternetConnection:
          hasInternetConnection ?? this.hasInternetConnection,
      isWebSocketConnected: isWebSocketConnected ?? this.isWebSocketConnected,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
      activeServer: activeServer ?? this.activeServer,
    );
  }

  @override
  List<Object?> get props => [
    status,
    themeMode,
    hasInternetConnection,
    isWebSocketConnected,
    errorMessage,
    isInitialized,
    activeServer,
  ];
}
