import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/config/server_config.dart';
import '../../../repositories/server/server_repository.dart';
import '../../../repositories/auth/auth_repository.dart';
import '../../../repositories/websocket/websocket_repository.dart';

part 'server_config_event.dart';
part 'server_config_state.dart';

class ServerConfigBloc extends Bloc<ServerConfigEvent, ServerConfigState> {
  final ServerRepository _serverRepository;
  final AuthRepository _authRepository;
  final WebSocketRepository? _websocketRepository;

  ServerConfigBloc({
    required ServerRepository serverRepository,
    required AuthRepository authRepository,
    WebSocketRepository? websocketRepository,
  }) : _serverRepository = serverRepository,
       _authRepository = authRepository,
       _websocketRepository = websocketRepository,
       super(const ServerConfigState()) {
    on<ServerConfigInitialized>(_onInitialized);
    on<ServerConfigLoadRequested>(_onLoadRequested);
    on<ServerConfigAdded>(_onServerAdded);
    on<ServerConfigUpdated>(_onServerUpdated);
    on<ServerConfigRemoved>(_onServerRemoved);
    on<ServerConfigActiveChanged>(_onActiveServerChanged);
    on<ServerConfigValidationRequested>(_onValidationRequested);
    on<ServerValidated>(_onServerValidated);
    on<ServerConfigError>(_onError);
    on<ServerConfigErrorCleared>(_onErrorCleared);
  }

  Future<void> _onInitialized(
    ServerConfigInitialized event,
    Emitter<ServerConfigState> emit,
  ) async {
    emit(state.copyWith(status: ServerConfigStatus.loading));

    try {
      await _serverRepository.initialize();
      final isWeb = _serverRepository.isWebPlatform;

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        state.copyWith(
          status: ServerConfigStatus.loaded,
          servers: servers,
          activeServer: activeServer,
          isWebPlatform: isWeb,
          isInitialized: true,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Failed to initialize server configurations: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadRequested(
    ServerConfigLoadRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    emit(state.copyWith(status: ServerConfigStatus.loading));

    try {
      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        state.copyWith(
          status: ServerConfigStatus.loaded,
          servers: servers,
          activeServer: activeServer,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Failed to load server configurations: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onServerAdded(
    ServerConfigAdded event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (state.isWebPlatform) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Server configuration is fixed in web mode',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ServerConfigStatus.addingServer));

    try {
      final sanitizedUrl = ServerConfig.sanitizeUrl(event.url);

      // Check for existing server with the same URL
      final existingServer = state.servers.any((s) => s.url == sanitizedUrl);
      if (existingServer) {
        emit(
          state.copyWith(
            status: ServerConfigStatus.error,
            error: 'A server with this URL already exists',
          ),
        );
        return;
      }

      // Validate the server before adding
      final isValid = await _serverRepository.validateServer(sanitizedUrl);
      if (!isValid) {
        emit(
          state.copyWith(
            status: ServerConfigStatus.error,
            error: 'Server validation failed',
          ),
        );
        return;
      }

      final finalName =
          event.name.isNotEmpty
              ? event.name
              : _generateNameFromUrl(sanitizedUrl);

      final newServer = await _serverRepository.addServer(
        finalName,
        sanitizedUrl,
      );

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        state.copyWith(
          status: ServerConfigStatus.serverAdded,
          servers: servers,
          activeServer: activeServer,
          serverBeingModified: newServer,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Failed to add server: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onServerUpdated(
    ServerConfigUpdated event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (state.isWebPlatform) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Server configuration is fixed in web mode',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ServerConfigStatus.updatingServer,
        serverBeingModified: state.servers.firstWhere(
          (s) => s.id == event.serverId,
          orElse: () => throw Exception('Server not found'),
        ),
      ),
    );

    try {
      String? sanitizedUrl;
      if (event.url != null) {
        sanitizedUrl = ServerConfig.sanitizeUrl(event.url!);

        // Check for existing server with the same URL
        final conflictingServer = state.servers.any(
          (s) => s.id != event.serverId && s.url == sanitizedUrl,
        );
        if (conflictingServer) {
          emit(
            state.copyWith(
              status: ServerConfigStatus.error,
              error: 'Another server with this URL already exists',
            ),
          );
          return;
        }

        final isValid = await _serverRepository.validateServer(sanitizedUrl);
        if (!isValid) {
          emit(
            state.copyWith(
              status: ServerConfigStatus.error,
              error: 'Server validation failed',
            ),
          );
          return;
        }
      }

      await _serverRepository.updateServer(
        event.serverId,
        name: event.name,
        url: sanitizedUrl,
      );

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      // If the updated server is the active one and the URL changed,
      // we need to reconnect websockets
      if (activeServer?.id == event.serverId &&
          sanitizedUrl != null &&
          _websocketRepository != null) {
        _websocketRepository!.disconnect();
      }

      emit(
        state.copyWith(
          status: ServerConfigStatus.serverUpdated,
          servers: servers,
          activeServer: activeServer,
          serverBeingModified: servers.firstWhere(
            (s) => s.id == event.serverId,
          ),
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Failed to update server: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onServerRemoved(
    ServerConfigRemoved event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (state.isWebPlatform) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Server configuration is fixed in web mode',
        ),
      );
      return;
    }

    final serverToRemove = state.servers.firstWhere(
      (s) => s.id == event.serverId,
      orElse: () => throw Exception('Server not found'),
    );

    emit(
      state.copyWith(
        status: ServerConfigStatus.removingServer,
        serverBeingModified: serverToRemove,
      ),
    );

    try {
      final isActiveServer = serverToRemove.isActive;

      // If removing the active server and we have websocket connections,
      // disconnect first
      if (isActiveServer && _websocketRepository != null) {
        _websocketRepository!.disconnect();
      }

      // Remove the server
      await _serverRepository.removeServer(event.serverId);

      // Refresh the servers list
      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        state.copyWith(
          status: ServerConfigStatus.serverRemoved,
          servers: servers,
          activeServer: activeServer,
          serverBeingModified: null,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Failed to remove server: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onActiveServerChanged(
    ServerConfigActiveChanged event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (state.isWebPlatform) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Server configuration is fixed in web mode',
        ),
      );
      return;
    }

    final newActiveServer = state.servers.firstWhere(
      (s) => s.id == event.serverId,
      orElse: () => throw Exception('Server not found'),
    );

    emit(
      state.copyWith(
        status: ServerConfigStatus.changingActiveServer,
        serverBeingModified: newActiveServer,
      ),
    );

    try {
      if (_websocketRepository != null) {
        _websocketRepository!.disconnect();
      }

      await _serverRepository.setActiveServer(event.serverId);
      await _authRepository.setCurrentServer(event.serverId);

      final servers = await _serverRepository.getServers();
      final activeServer = _serverRepository.activeServer;

      emit(
        state.copyWith(
          status: ServerConfigStatus.activeServerChanged,
          servers: servers,
          activeServer: activeServer,
          serverBeingModified: null,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Failed to change active server: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onValidationRequested(
    ServerConfigValidationRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ServerConfigStatus.validating,
        validatingUrl: event.url,
        validationSuccessful: false,
      ),
    );

    try {
      final sanitizedUrl = ServerConfig.sanitizeUrl(event.url);
      final isValid = await _serverRepository.validateServer(sanitizedUrl);

      add(ServerValidated(url: sanitizedUrl, isValid: isValid));
    } catch (e) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Validation failed: ${e.toString()}',
          validatingUrl: null,
        ),
      );
    }
  }

  void _onServerValidated(
    ServerValidated event,
    Emitter<ServerConfigState> emit,
  ) {
    if (event.isValid) {
      emit(
        state.copyWith(
          status: ServerConfigStatus.loaded,
          validatingUrl: null,
          validationSuccessful: true,
          error: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ServerConfigStatus.error,
          error: 'Server validation failed for ${event.url}',
          validatingUrl: null,
          validationSuccessful: false,
        ),
      );
    }
  }

  void _onError(ServerConfigError event, Emitter<ServerConfigState> emit) {
    emit(state.copyWith(status: ServerConfigStatus.error, error: event.error));
  }

  void _onErrorCleared(
    ServerConfigErrorCleared event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(state.copyWith(status: ServerConfigStatus.loaded, error: null));
  }

  String _generateNameFromUrl(String url) {
    String name = url.replaceFirst(RegExp(r'https?://'), '');
    name = name.replaceFirst(RegExp(r'^www\.'), '');
    name = name.split('/').first;
    return name;
  }
}
