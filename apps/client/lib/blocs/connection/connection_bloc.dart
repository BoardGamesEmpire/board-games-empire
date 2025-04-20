import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/config/server_config.dart';
import '../../repositories/websocket/websocket_repository.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final WebSocketRepository _websocketRepository;
  StreamSubscription? _connectionStatusSubscription;

  ConnectionBloc({required WebSocketRepository websocketRepository})
    : _websocketRepository = websocketRepository,
      super(const ConnectionState.disconnected()) {
    on<ConnectionRequested>(_onConnectionRequested);
    on<ConnectionDisconnectRequested>(_onDisconnectRequested);
    on<ConnectionStatusChanged>(_onConnectionStatusChanged);
    on<ConnectionServerChanged>(_onServerChanged);

    _connectionStatusSubscription = _websocketRepository.connectionStatus
        .listen((isConnected) => add(ConnectionStatusChanged(isConnected)));
  }

  Future<void> _onConnectionRequested(
    ConnectionRequested event,
    Emitter<ConnectionState> emit,
  ) async {
    if (state.status == ConnectionStatus.connected ||
        state.status == ConnectionStatus.connecting) {
      return;
    }

    emit(state.copyWith(status: ConnectionStatus.connecting));

    try {
      final success = await _websocketRepository.connect(
        event.server.url,
        event.server.id,
      );

      if (success) {
        emit(
          ConnectionState.connected(
            server: event.server,
            serverId: event.server.id,
          ),
        );
      } else {
        emit(
          ConnectionState.error(
            'Failed to connect to ${event.server.name}',
            event.server,
          ),
        );
      }
    } catch (e) {
      emit(
        ConnectionState.error(
          'Connection error: ${e.toString()}',
          event.server,
        ),
      );
    }
  }

  Future<void> _onDisconnectRequested(
    ConnectionDisconnectRequested event,
    Emitter<ConnectionState> emit,
  ) async {
    if (state.status == ConnectionStatus.disconnected) {
      return;
    }

    _websocketRepository.disconnect();
    emit(const ConnectionState.disconnected());
  }

  void _onConnectionStatusChanged(
    ConnectionStatusChanged event,
    Emitter<ConnectionState> emit,
  ) {
    if (event.isConnected && state.status == ConnectionStatus.disconnected) {
      emit(
        ConnectionState.connected(
          server: state.server,
          serverId: state.serverId,
        ),
      );
    } else if (!event.isConnected &&
        state.status == ConnectionStatus.connected) {
      emit(
        ConnectionState.disconnected(
          server: state.server,
          serverId: state.serverId,
        ),
      );
    }
  }

  Future<void> _onServerChanged(
    ConnectionServerChanged event,
    Emitter<ConnectionState> emit,
  ) async {
    if (state.serverId == event.server.id) {
      return;
    }

    _websocketRepository.disconnect();
    emit(ConnectionState.disconnected(server: event.server));

    add(ConnectionRequested(event.server));
  }

  @override
  Future<void> close() {
    _connectionStatusSubscription?.cancel();
    return super.close();
  }
}
