import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/config/server_config.dart';
import '../../../repositories/server/server_repository.dart';

part 'server_config_event.dart';
part 'server_config_state.dart';

class ServerConfigBloc extends Bloc<ServerConfigEvent, ServerConfigState> {
  final ServerRepository _serverRepository;

  ServerConfigBloc({required ServerRepository serverRepository})
    : _serverRepository = serverRepository,
      super(const ServerConfigState()) {
    on<ServerConfigInitialized>(_onInitialized);
    on<ServerConfigNameChanged>(_onNameChanged);
    on<ServerConfigUrlChanged>(_onUrlChanged);
    on<ServerConfigValidationRequested>(_onValidationRequested);
    on<ServerConfigAddRequested>(_onAddRequested);
    on<ServerConfigValidationCompleted>(_onValidationCompleted);
  }

  void _onInitialized(
    ServerConfigInitialized event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(
      state.copyWith(
        isInitialSetup: event.isInitialSetup,
        isWebPlatform: _serverRepository.isWebPlatform,
      ),
    );
  }

  void _onNameChanged(
    ServerConfigNameChanged event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(state.copyWith(name: event.name, error: null));
  }

  void _onUrlChanged(
    ServerConfigUrlChanged event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(state.copyWith(url: event.url, error: null));
  }

  Future<void> _onValidationRequested(
    ServerConfigValidationRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (state.url.isEmpty) {
      emit(state.copyWith(error: 'Please enter a server URL'));
      return;
    }

    emit(state.copyWith(isValidating: true, error: null));

    try {
      final sanitizedUrl = ServerConfig.sanitizeUrl(state.url);
      final isValid = await _serverRepository.validateServer(sanitizedUrl);

      add(ServerConfigValidationCompleted(isValid));
    } catch (e) {
      emit(state.copyWith(isValidating: false, error: e.toString()));
    }
  }

  void _onValidationCompleted(
    ServerConfigValidationCompleted event,
    Emitter<ServerConfigState> emit,
  ) {
    emit(
      state.copyWith(
        isValidating: false,
        isValidated: event.isValid,
        error: event.isValid ? null : 'Server validation failed',
      ),
    );
  }

  Future<void> _onAddRequested(
    ServerConfigAddRequested event,
    Emitter<ServerConfigState> emit,
  ) async {
    if (state.url.isEmpty) {
      emit(state.copyWith(error: 'Please enter a server URL'));
      return;
    }

    emit(state.copyWith(isAdding: true, error: null));

    try {
      final server = await _serverRepository.addServer(
        state.name.isNotEmpty ? state.name : _generateNameFromUrl(state.url),
        state.url,
      );

      emit(state.copyWith(isAdding: false, isAdded: true, addedServer: server));
    } catch (e) {
      emit(state.copyWith(isAdding: false, error: e.toString()));
    }
  }

  String _generateNameFromUrl(String url) {
    String name = url.replaceFirst(RegExp(r'https?://'), '');
    name = name.replaceFirst(RegExp(r'^www\.'), '');
    name = name.split('/').first;
    return name;
  }
}
