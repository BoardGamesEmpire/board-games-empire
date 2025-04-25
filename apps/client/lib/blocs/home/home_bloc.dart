import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/config/server_config.dart';
import '../../../repositories/auth/auth_repository.dart';
import '../../../repositories/websocket/websocket_repository.dart';
import '../server/server_config/server_config_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WebSocketRepository _websocketRepository;
  final AuthRepository _authRepository;
  final ServerConfigBloc _serverConfigBloc;
  StreamSubscription? _websocketStatusSubscription;
  StreamSubscription? _serverConfigSubscription;

  HomeBloc({
    required WebSocketRepository websocketRepository,
    required AuthRepository authRepository,
    required ServerConfigBloc serverConfigBloc,
  }) : _websocketRepository = websocketRepository,
       _authRepository = authRepository,
       _serverConfigBloc = serverConfigBloc,
       super(const HomeState()) {
    on<HomeInitialized>(_onInitialized);
    on<HomeWebSocketConnectRequested>(_onWebSocketConnectRequested);
    on<HomeWebSocketStatusChanged>(_onWebSocketStatusChanged);
    on<HomeLogoutRequested>(_onLogoutRequested);
    on<HomeLogoutConfirmed>(_onLogoutConfirmed);
    on<HomeLogoutCancelled>(_onLogoutCancelled);
    on<HomeServerConfigChanged>(_onServerConfigChanged);
  }

  void _onInitialized(HomeInitialized event, Emitter<HomeState> emit) {
    // Subscribe to websocket status changes
    _websocketStatusSubscription = _websocketRepository.connectionStatus.listen(
      (isConnected) => add(HomeWebSocketStatusChanged(isConnected)),
    );

    // Subscribe to server config changes
    _serverConfigSubscription = _serverConfigBloc.stream.listen((
      serverConfigState,
    ) {
      if (serverConfigState.status == ServerConfigStatus.activeServerChanged) {
        add(HomeServerConfigChanged(serverConfigState.activeServer));
      }
    });

    // Initialize the server config bloc if not already initialized
    if (!_serverConfigBloc.state.isInitialized) {
      _serverConfigBloc.add(const ServerConfigInitialized());
    }

    // Try to connect to WebSocket if we have an active server
    if (_serverConfigBloc.state.activeServer != null) {
      add(const HomeWebSocketConnectRequested());
    }
  }

  Future<void> _onWebSocketConnectRequested(
    HomeWebSocketConnectRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isConnecting || state.isConnected) return;

    emit(state.copyWith(connectionStatus: ConnectionStatus.connecting));

    try {
      final activeServer = _serverConfigBloc.state.activeServer;
      if (activeServer == null) {
        emit(
          state.copyWith(
            connectionStatus: ConnectionStatus.disconnected,
            error: 'No active server',
          ),
        );
        return;
      }

      await _websocketRepository.connect(activeServer.url, activeServer.id);
    } catch (e) {
      emit(
        state.copyWith(
          connectionStatus: ConnectionStatus.disconnected,
          error: 'Failed to connect: ${e.toString()}',
        ),
      );
    }
  }

  void _onWebSocketStatusChanged(
    HomeWebSocketStatusChanged event,
    Emitter<HomeState> emit,
  ) {
    final connectionStatus =
        event.isConnected
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected;

    emit(state.copyWith(connectionStatus: connectionStatus, error: null));
  }

  void _onLogoutRequested(HomeLogoutRequested event, Emitter<HomeState> emit) {
    emit(state.copyWith(showLogoutConfirmation: true));
  }

  Future<void> _onLogoutConfirmed(
    HomeLogoutConfirmed event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(showLogoutConfirmation: false, isLoggingOut: true));

    try {
      // Disconnect WebSocket before logout
      _websocketRepository.disconnect();

      await _authRepository.logout(allSessions: event.allSessions);
      emit(state.copyWith(isLoggingOut: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoggingOut: false,
          error: 'Logout error: ${e.toString()}',
        ),
      );
    }
  }

  void _onLogoutCancelled(HomeLogoutCancelled event, Emitter<HomeState> emit) {
    emit(state.copyWith(showLogoutConfirmation: false));
  }

  void _onServerConfigChanged(
    HomeServerConfigChanged event,
    Emitter<HomeState> emit,
  ) {
    // When active server changes, attempt to reconnect
    if (event.activeServer != null) {
      add(const HomeWebSocketConnectRequested());
    }
  }

  @override
  Future<void> close() {
    _websocketStatusSubscription?.cancel();
    _serverConfigSubscription?.cancel();
    return super.close();
  }
}
