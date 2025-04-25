part of 'app_initialization_bloc.dart';

enum AppInitializationStatus { initial, loading, success, failure }

class AppInitializationState extends Equatable {
  final AppInitializationStatus status;
  final bool serverInitialized;
  final bool authInitialized;
  final bool themeInitialized;
  final double progress;
  final String? error;

  const AppInitializationState({
    this.status = AppInitializationStatus.initial,
    this.serverInitialized = false,
    this.authInitialized = false,
    this.themeInitialized = false,
    this.progress = 0.0,
    this.error,
  });

  bool get isInitializing => status == AppInitializationStatus.loading;
  bool get isInitialized => status == AppInitializationStatus.success;
  bool get hasError => status == AppInitializationStatus.failure;

  AppInitializationState copyWith({
    AppInitializationStatus? status,
    bool? serverInitialized,
    bool? authInitialized,
    bool? themeInitialized,
    double? progress,
    String? error,
  }) {
    return AppInitializationState(
      status: status ?? this.status,
      serverInitialized: serverInitialized ?? this.serverInitialized,
      authInitialized: authInitialized ?? this.authInitialized,
      themeInitialized: themeInitialized ?? this.themeInitialized,
      progress: progress ?? this.progress,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    serverInitialized,
    authInitialized,
    themeInitialized,
    progress,
    error,
  ];
}
