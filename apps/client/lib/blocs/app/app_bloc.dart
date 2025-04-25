import 'dart:async';

import 'package:board_games_empire/blocs/app/initialization/app_initialization_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:board_games_empire/blocs/websocket/websocket_bloc.dart';
import 'package:board_games_empire/models/config/server_config.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final InternetConnectionChecker _connectionChecker;
  final AppInitializationBloc _initializationBloc;
  final WebSocketBloc _webSocketBloc;

  StreamSubscription? _webSocketStatusSubscription;

  AppBloc({
    required InternetConnectionChecker connectionChecker,
    required AppInitializationBloc initializationBloc,
    required WebSocketBloc webSocketBloc,
  }) : _connectionChecker = connectionChecker,
       _webSocketBloc = webSocketBloc,
       _initializationBloc = initializationBloc,
       super(const AppState()) {
    on<AppStarted>(_onAppStarted);
    on<AppRequestedInitialization>(_onRequestedInitialization);
    on<AppInitialized>(_onAppInitialized);
    on<AppConnectionRequested>(_onConnectionRequested);
    on<AppConnectionStatusChanged>(_onConnectionStatusChanged);
    on<ThemeChanged>(_onThemeChanged);
    on<InternetConnectionChanged>(_onInternetConnectionChanged);
    on<AppError>(_onAppError);
    on<AppErrorDismissed>(_onAppErrorDismissed);

    _webSocketStatusSubscription = _webSocketBloc.stream
        .where((state) => state is WebSocketState)
        .cast<WebSocketState>()
        .map((state) => state.isConnected)
        .distinct()
        .listen((isConnected) => add(AppConnectionStatusChanged(isConnected)));

    // Subscribe to internet connection status
    _connectionChecker.onStatusChange.listen((status) {
      add(
        InternetConnectionChanged(status == InternetConnectionStatus.connected),
      );
    });
  }

  void _onThemeChanged(ThemeChanged event, Emitter<AppState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onInternetConnectionChanged(
    InternetConnectionChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(hasInternetConnection: event.hasConnection));
  }

  void _onAppError(AppError event, Emitter<AppState> emit) {
    emit(state.copyWith(errorMessage: event.message));
  }

  void _onAppErrorDismissed(AppErrorDismissed event, Emitter<AppState> emit) {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> _onAppInitialized(
    AppInitialized event,
    Emitter<AppState> emit,
  ) async {
    // Handle the initialization data
    final initialStatus =
        (event.hasServers && event.isAuthenticated)
            ? AppStatus.authenticated
            : event.hasServers
            ? AppStatus.unauthenticated
            : AppStatus.needsServerSetup;

    emit(
      state.copyWith(
        status: initialStatus,
        activeServer: event.activeServer,
        isInitialized: true,
      ),
    );

    if (initialStatus == AppStatus.authenticated) {
      add(const AppConnectionRequested());
    }
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) {
    emit(state.copyWith(status: AppStatus.initializing));

    // Check internet connectivity first
    add(const AppRequestedInitialization());
  }

  void _onRequestedInitialization(
    AppRequestedInitialization event,
    Emitter<AppState> emit,
  ) {
    _initializationBloc.add(const AppInitStarted());
  }

  void _onConnectionRequested(
    AppConnectionRequested event,
    Emitter<AppState> emit,
  ) {
    if (state.activeServer != null) {
      _webSocketBloc.add(WebSocketConnectRequested(state.activeServer!));
    }
  }

  // Add disposal of subscriptions
  @override
  Future<void> close() {
    _webSocketStatusSubscription?.cancel();
    return super.close();
  }

  void _onConnectionStatusChanged(
    AppConnectionStatusChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(isWebSocketConnected: event.isConnected));
  }
}
