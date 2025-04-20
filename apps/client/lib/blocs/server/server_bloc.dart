import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/config/server_config.dart';
import '../../repositories/server/server_repository.dart';

part 'server_event.dart';
part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  final ServerRepository _serverRepository;

  ServerBloc({required ServerRepository serverRepository})
    : _serverRepository = serverRepository,
      super(const ServerState.initial()) {
    on<ServerInitializeRequested>(_onInitializeRequested);
    on<ServerAddRequested>(_onAddRequested);
    on<ServerUpdateRequested>(_onUpdateRequested);
    on<ServerRemoveRequested>(_onRemoveRequested);
    on<ServerActiveChanged>(_onActiveChanged);
    on<ServerConnectionTest>(_onConnectionTest);
  }

  Future<void> _onInitializeRequested(
    ServerInitializeRequested event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));

    try {
      await _serverRepository.initialize();
      final servers = _serverRepository.servers;
      final activeServer = _serverRepository.activeServer;

      if (servers.isEmpty) {
        emit(const ServerState.noServers());
      } else {
        emit(
          ServerState.loaded(
            servers: servers,
            activeServer: activeServer,
            isWebPlatform: _serverRepository.isWebPlatform,
          ),
        );
      }
    } catch (e) {
      emit(
        ServerState.error(
          'Failed to load server configurations: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddRequested(
    ServerAddRequested event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));

    try {
      final newServer = await _serverRepository.addServer(
        event.name,
        event.url,
      );

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        ServerState.loaded(
          servers: servers,
          activeServer: activeServer,
          isWebPlatform: _serverRepository.isWebPlatform,
          lastAddedServer: newServer,
        ),
      );
    } catch (e) {
      emit(ServerState.error('Failed to add server: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateRequested(
    ServerUpdateRequested event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));

    try {
      await _serverRepository.updateServer(
        event.serverId,
        name: event.name,
        url: event.url,
      );

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        ServerState.loaded(
          servers: servers,
          activeServer: activeServer,
          isWebPlatform: _serverRepository.isWebPlatform,
        ),
      );
    } catch (e) {
      emit(ServerState.error('Failed to update server: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveRequested(
    ServerRemoveRequested event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));

    try {
      await _serverRepository.removeServer(event.serverId);

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      if (servers.isEmpty) {
        emit(const ServerState.noServers());
      } else {
        emit(
          ServerState.loaded(
            servers: servers,
            activeServer: activeServer,
            isWebPlatform: _serverRepository.isWebPlatform,
          ),
        );
      }
    } catch (e) {
      emit(ServerState.error('Failed to remove server: ${e.toString()}'));
    }
  }

  Future<void> _onActiveChanged(
    ServerActiveChanged event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.loading));

    try {
      await _serverRepository.setActiveServer(event.serverId);

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        ServerState.loaded(
          servers: servers,
          activeServer: activeServer,
          isWebPlatform: _serverRepository.isWebPlatform,
        ),
      );
    } catch (e) {
      emit(
        ServerState.error('Failed to change active server: ${e.toString()}'),
      );
    }
  }

  Future<void> _onConnectionTest(
    ServerConnectionTest event,
    Emitter<ServerState> emit,
  ) async {
    emit(state.copyWith(status: ServerStatus.testing));

    try {
      final success = await _serverRepository.validateServer(event.url);

      if (success) {
        emit(
          state.copyWith(
            status: ServerStatus.testSuccess,
            lastTestedUrl: event.url,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ServerStatus.testFailure,
            lastTestedUrl: event.url,
            error: 'Server validation failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerStatus.testFailure,
          lastTestedUrl: event.url,
          error: e.toString(),
        ),
      );
    }
  }
}
