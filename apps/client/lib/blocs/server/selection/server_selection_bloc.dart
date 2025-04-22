import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/config/server_config.dart';
import '../../../../repositories/server/server_repository.dart';
import '../../../../repositories/auth/auth_repository.dart';

part './server_selection_event.dart';
part './server_selection_state.dart';

class ServerSelectionBloc
    extends Bloc<ServerSelectionEvent, ServerSelectionState> {
  final ServerRepository _serverRepository;
  final AuthRepository _authRepository;

  ServerSelectionBloc({
    required ServerRepository serverRepository,
    required AuthRepository authRepository,
  }) : _serverRepository = serverRepository,
       _authRepository = authRepository,
       super(const ServerSelectionState()) {
    on<ServerSelectionInitialized>(_onInitialized);
    on<ServerSelectionRefreshRequested>(_onRefreshRequested);
    on<ServerSelected>(_onServerSelected);
    on<ServerAddRequested>(_onServerAddRequested);
    on<ServerAddCompleted>(_onServerAddCompleted);
    on<ServerRemovalRequested>(_onServerRemovalRequested);
    on<ServerRemovalConfirmed>(_onServerRemovalConfirmed);
    on<ServerRemovalCancelled>(_onServerRemovalCancelled);
  }

  Future<void> _onInitialized(
    ServerSelectionInitialized event,
    Emitter<ServerSelectionState> emit,
  ) async {
    emit(state.copyWith(status: ServerSelectionStatus.loading));

    try {
      await _serverRepository.initialize();
      final servers = await _serverRepository.getServers();

      final isWebPlatform = _serverRepository.isWebPlatform;

      if (servers.isEmpty) {
        emit(
          state.copyWith(
            status: ServerSelectionStatus.empty,
            isWebPlatform: isWebPlatform,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ServerSelectionStatus.success,
            servers: servers,
            activeServer: _serverRepository.activeServer,
            isWebPlatform: isWebPlatform,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerSelectionStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    ServerSelectionRefreshRequested event,
    Emitter<ServerSelectionState> emit,
  ) async {
    emit(state.copyWith(status: ServerSelectionStatus.loading));

    try {
      final servers = await _serverRepository.getServers();

      if (servers.isEmpty) {
        emit(
          state.copyWith(
            status: ServerSelectionStatus.empty,
            servers: const [],
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ServerSelectionStatus.success,
            servers: servers,
            activeServer: _serverRepository.activeServer,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerSelectionStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onServerSelected(
    ServerSelected event,
    Emitter<ServerSelectionState> emit,
  ) async {
    emit(state.copyWith(status: ServerSelectionStatus.loading));

    try {
      await _serverRepository.setActiveServer(event.serverId);

      // Reset auth for new server
      if (_authRepository.accessToken != null) {
        await _authRepository.setCurrentServer(event.serverId);
      }

      emit(
        state.copyWith(
          status: ServerSelectionStatus.activeServerChanged,
          activeServer: _serverRepository.activeServer,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerSelectionStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _onServerAddRequested(
    ServerAddRequested event,
    Emitter<ServerSelectionState> emit,
  ) {
    emit(state.copyWith(status: ServerSelectionStatus.navigatingToAdd));
  }

  void _onServerAddCompleted(
    ServerAddCompleted event,
    Emitter<ServerSelectionState> emit,
  ) {
    if (event.server != null) {
      add(ServerSelected(event.server!.id));
    } else {
      add(const ServerSelectionRefreshRequested());
    }
  }

  void _onServerRemovalRequested(
    ServerRemovalRequested event,
    Emitter<ServerSelectionState> emit,
  ) {
    emit(state.copyWith(serverToRemove: event.server, confirmingRemoval: true));
  }

  Future<void> _onServerRemovalConfirmed(
    ServerRemovalConfirmed event,
    Emitter<ServerSelectionState> emit,
  ) async {
    if (state.serverToRemove == null) return;

    emit(
      state.copyWith(
        status: ServerSelectionStatus.loading,
        confirmingRemoval: false,
      ),
    );

    try {
      await _serverRepository.removeServer(state.serverToRemove!.id);
      final servers = await _serverRepository.getServers();

      if (servers.isEmpty) {
        emit(
          state.copyWith(
            status: ServerSelectionStatus.empty,
            servers: const [],
            serverToRemove: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ServerSelectionStatus.success,
            servers: servers,
            activeServer: _serverRepository.activeServer,
            serverToRemove: null,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerSelectionStatus.failure,
          error: e.toString(),
          serverToRemove: null,
        ),
      );
    }
  }

  void _onServerRemovalCancelled(
    ServerRemovalCancelled event,
    Emitter<ServerSelectionState> emit,
  ) {
    emit(state.copyWith(confirmingRemoval: false, serverToRemove: null));
  }
}
