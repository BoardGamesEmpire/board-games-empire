import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth/auth_repository.dart';
import '../../../repositories/server/server_repository.dart';

part 'app_initialization_event.dart';
part 'app_initialization_state.dart';

class AppInitializationBloc
    extends Bloc<AppInitializationEvent, AppInitializationState> {
  final ServerRepository _serverRepository;
  final AuthRepository _authRepository;

  AppInitializationBloc({
    required ServerRepository serverRepository,
    required AuthRepository authRepository,
  }) : _serverRepository = serverRepository,
       _authRepository = authRepository,
       super(const AppInitializationState()) {
    on<AppInitStarted>(_onAppStarted);
    on<ServerDataLoaded>(_onServerDataLoaded);
    on<AuthDataLoaded>(_onAuthDataLoaded);
    on<ThemeLoaded>(_onThemeLoaded);
    on<AppInitializationCompleted>(_onInitializationCompleted);
    on<AppInitializationFailed>(_onInitializationFailed);
  }

  Future<void> _onAppStarted(
    AppInitStarted event,
    Emitter<AppInitializationState> emit,
  ) async {
    emit(state.copyWith(status: AppInitializationStatus.loading));

    try {
      // First, initialize the server repository
      add(const ServerDataLoaded());
    } catch (e) {
      add(AppInitializationFailed('Failed to start app: ${e.toString()}'));
    }
  }

  Future<void> _onServerDataLoaded(
    ServerDataLoaded event,
    Emitter<AppInitializationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: AppInitializationStatus.loading,
          serverInitialized: true,
          progress: 0.33,
        ),
      );

      // Initialize server repository
      await _serverRepository.initialize();

      // Now load auth data
      add(const AuthDataLoaded());
    } catch (e) {
      add(
        AppInitializationFailed('Failed to load server data: ${e.toString()}'),
      );
    }
  }

  Future<void> _onAuthDataLoaded(
    AuthDataLoaded event,
    Emitter<AppInitializationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: AppInitializationStatus.loading,
          authInitialized: true,
          progress: 0.66,
        ),
      );

      // Set the active server in the auth repository
      final activeServer = _serverRepository.activeServer;
      if (activeServer != null) {
        await _authRepository.setCurrentServer(activeServer.id);
      }

      // Now load theme data
      add(const ThemeLoaded());
    } catch (e) {
      add(
        AppInitializationFailed(
          'Failed to load authentication data: ${e.toString()}',
        ),
      );
    }
  }

  void _onThemeLoaded(ThemeLoaded event, Emitter<AppInitializationState> emit) {
    try {
      emit(
        state.copyWith(
          status: AppInitializationStatus.loading,
          themeInitialized: true,
          progress: 0.9,
        ),
      );

      // Complete initialization
      add(const AppInitializationCompleted());
    } catch (e) {
      add(
        AppInitializationFailed('Failed to load theme data: ${e.toString()}'),
      );
    }
  }

  void _onInitializationCompleted(
    AppInitializationCompleted event,
    Emitter<AppInitializationState> emit,
  ) {
    emit(
      state.copyWith(status: AppInitializationStatus.success, progress: 1.0),
    );
  }

  void _onInitializationFailed(
    AppInitializationFailed event,
    Emitter<AppInitializationState> emit,
  ) {
    emit(
      state.copyWith(
        status: AppInitializationStatus.failure,
        error: event.error,
      ),
    );
  }
}
