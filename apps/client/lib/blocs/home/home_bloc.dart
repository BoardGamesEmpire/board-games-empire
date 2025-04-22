import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth/auth_repository.dart';
import '../../../repositories/websocket/websocket_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WebSocketRepository _websocketRepository;
  final AuthRepository _authRepository;

  HomeBloc({
    required WebSocketRepository websocketRepository,
    required AuthRepository authRepository,
  }) : _websocketRepository = websocketRepository,
       _authRepository = authRepository,
       super(const HomeState()) {
    on<HomeInitialized>(_onInitialized);
    on<HomeWebSocketConnectRequested>(_onWebSocketConnectRequested);
    on<HomeWebSocketStatusChanged>(_onWebSocketStatusChanged);
    on<HomeLogoutRequested>(_onLogoutRequested);
    on<HomeLogoutConfirmed>(_onLogoutConfirmed);
    on<HomeLogoutCancelled>(_onLogoutCancelled);
  }

  void _onInitialized(HomeInitialized event, Emitter<HomeState> emit) {
    // Subscribe to websocket status changes
    _websocketRepository.connectionStatus.listen(
      (isConnected) => add(HomeWebSocketStatusChanged(isConnected)),
    );

    add(const HomeWebSocketConnectRequested());
  }

  Future<void> _onWebSocketConnectRequested(
    HomeWebSocketConnectRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isConnecting || state.isConnected) return;

    emit(state.copyWith(connectionStatus: ConnectionStatus.connecting));

    try {
      final serverId = _websocketRepository.currentServerId;
      if (serverId == null) {
        emit(
          state.copyWith(
            connectionStatus: ConnectionStatus.disconnected,
            error: 'No active server',
          ),
        );
        return;
      }

      await _websocketRepository.connect(
        _websocketRepository.currentServerId ?? '',
        _websocketRepository.currentServerId ?? '',
      );
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
}
