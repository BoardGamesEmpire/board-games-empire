import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/config/server_config.dart';
import '../../repositories/websocket/websocket_repository.dart';
import '../error/error_bloc.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketRepository _websocketRepository;
  final ErrorBloc _errorBloc;
  StreamSubscription? _connectionStatusSubscription;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  static const int maxReconnectAttempts = 5;

  WebSocketBloc({
    required WebSocketRepository websocketRepository,
    required ErrorBloc errorBloc,
  }) : _websocketRepository = websocketRepository,
       _errorBloc = errorBloc,
       super(const WebSocketState()) {
    on<WebSocketConnectRequested>(_onConnectRequested);
    on<WebSocketDisconnectRequested>(_onDisconnectRequested);
    on<WebSocketStatusChanged>(_onStatusChanged);
    on<WebSocketMessageReceived>(_onMessageReceived);
    on<WebSocketReconnectAttempt>(_onReconnectAttempt);
    on<WebSocketServerChanged>(_onServerChanged);
    on<WebSocketAutoReconnectChanged>(_onAutoReconnectChanged);

    // Subscribe to WebSocket status changes
    _connectionStatusSubscription = _websocketRepository.connectionStatus
        .listen((isConnected) => add(WebSocketStatusChanged(isConnected)));
  }

  Future<void> _onConnectRequested(
    WebSocketConnectRequested event,
    Emitter<WebSocketState> emit,
  ) async {
    if (state.status == WebSocketStatus.connected ||
        state.status == WebSocketStatus.connecting) {
      return;
    }

    _reconnectAttempt = 0;
    emit(
      state.copyWith(
        status: WebSocketStatus.connecting,
        server: event.server,
        error: null,
      ),
    );

    try {
      final success = await _websocketRepository.connect(
        event.server.url,
        event.server.id,
      );

      if (!success) {
        emit(
          state.copyWith(
            status: WebSocketStatus.failed,
            error: 'Failed to connect to WebSocket server',
          ),
        );

        _errorBloc.add(
          const NetworkErrorReported(
            'Failed to establish WebSocket connection',
          ),
        );

        _scheduleReconnect();
      }
    } catch (e) {
      emit(state.copyWith(status: WebSocketStatus.failed, error: e.toString()));

      _errorBloc.add(
        NetworkErrorReported('WebSocket connection error: ${e.toString()}'),
      );

      _scheduleReconnect();
    }
  }

  void _onDisconnectRequested(
    WebSocketDisconnectRequested event,
    Emitter<WebSocketState> emit,
  ) {
    _cancelReconnect();
    _websocketRepository.disconnect();
    emit(state.copyWith(status: WebSocketStatus.disconnected, error: null));
  }

  void _onStatusChanged(
    WebSocketStatusChanged event,
    Emitter<WebSocketState> emit,
  ) {
    final newStatus =
        event.isConnected
            ? WebSocketStatus.connected
            : WebSocketStatus.disconnected;

    // If we were connecting and now we're connected, cancel any reconnect timer
    if (state.status == WebSocketStatus.connecting && event.isConnected) {
      _cancelReconnect();
      _reconnectAttempt = 0;
    }

    // If we were connected and now we're disconnected, and auto-reconnect is enabled
    if (state.status == WebSocketStatus.connected &&
        !event.isConnected &&
        state.autoReconnect) {
      _scheduleReconnect();
    }

    emit(state.copyWith(status: newStatus, error: null));
  }

  void _onMessageReceived(
    WebSocketMessageReceived event,
    Emitter<WebSocketState> emit,
  ) {
    emit(state.copyWith(lastMessage: event.message));
  }

  Future<void> _onReconnectAttempt(
    WebSocketReconnectAttempt event,
    Emitter<WebSocketState> emit,
  ) async {
    if (state.server == null ||
        !state.autoReconnect ||
        state.status == WebSocketStatus.connected) {
      return;
    }

    _reconnectAttempt++;

    emit(
      state.copyWith(
        status: WebSocketStatus.connecting,
        reconnectAttempt: _reconnectAttempt,
        error: null,
      ),
    );

    try {
      final success = await _websocketRepository.connect(
        state.server!.url,
        state.server!.id,
      );

      if (!success && _reconnectAttempt < maxReconnectAttempts) {
        _scheduleReconnect();
      } else if (!success) {
        emit(
          state.copyWith(
            status: WebSocketStatus.failed,
            error: 'Failed to reconnect after $maxReconnectAttempts attempts',
          ),
        );

        _errorBloc.add(
          const NetworkErrorReported(
            'Failed to reconnect to WebSocket server after multiple attempts',
            shouldShowDialog: true,
          ),
        );
      }
    } catch (e) {
      if (_reconnectAttempt < maxReconnectAttempts) {
        _scheduleReconnect();
      } else {
        emit(
          state.copyWith(
            status: WebSocketStatus.failed,
            error: 'Failed to reconnect: ${e.toString()}',
          ),
        );

        _errorBloc.add(
          NetworkErrorReported(
            'WebSocket reconnection error: ${e.toString()}',
            shouldShowDialog: true,
          ),
        );
      }
    }
  }

  void _onServerChanged(
    WebSocketServerChanged event,
    Emitter<WebSocketState> emit,
  ) {
    _cancelReconnect();
    _websocketRepository.disconnect();

    emit(
      state.copyWith(
        status: WebSocketStatus.disconnected,
        server: event.server,
        error: null,
      ),
    );

    // Auto-connect to the new server if enabled
    if (state.autoConnect) {
      add(WebSocketConnectRequested(event.server));
    }
  }

  void _onAutoReconnectChanged(
    WebSocketAutoReconnectChanged event,
    Emitter<WebSocketState> emit,
  ) {
    emit(state.copyWith(autoReconnect: event.enabled));

    if (!event.enabled) {
      _cancelReconnect();
    }
  }

  void _scheduleReconnect() {
    _cancelReconnect();

    if (!state.autoReconnect || _reconnectAttempt >= maxReconnectAttempts) {
      return;
    }

    // Exponential backoff: 2^n * 1000ms (1s, 2s, 4s, 8s, 16s)
    final backoffTime = (1 << _reconnectAttempt) * 1000;
    _reconnectTimer = Timer(Duration(milliseconds: backoffTime), () {
      add(const WebSocketReconnectAttempt());
    });
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  Future<void> close() {
    _connectionStatusSubscription?.cancel();
    _cancelReconnect();
    return super.close();
  }
}
