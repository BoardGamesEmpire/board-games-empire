import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final InternetConnectionChecker _connectionChecker;

  AppBloc({InternetConnectionChecker? connectionChecker})
    : _connectionChecker =
          connectionChecker ?? InternetConnectionChecker.createInstance(),
      super(const AppState()) {
    on<AppStarted>(_onAppStarted);
    on<ThemeChanged>(_onThemeChanged);
    on<InternetConnectionChanged>(_onInternetConnectionChanged);
    on<AppError>(_onAppError);
    on<AppErrorDismissed>(_onAppErrorDismissed);

    _connectionChecker.onStatusChange.listen((status) {
      add(
        InternetConnectionChanged(status == InternetConnectionStatus.connected),
      );
    });
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.initializing));

    try {
      final hasInternet = await _connectionChecker.hasConnection;

      emit(
        state.copyWith(
          status: AppStatus.initialized,
          hasInternetConnection: hasInternet,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.error,
          errorMessage: 'Failed to initialize app: ${e.toString()}',
        ),
      );
    }
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
}
