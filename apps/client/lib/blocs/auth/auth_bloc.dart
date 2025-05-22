import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authStatusSubscription;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState.unknown()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSessionUpdated>(_onAuthSessionUpdated);
    on<AuthServerChanged>(_onAuthServerChanged);

    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthStatusChanged(status, _authRepository.accessToken)),
    );
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthStatus.authenticated:
        final user = await _authRepository.getCurrentUser();
        return emit(
          user != null
              ? AuthState.authenticated(user, event.token)
              : const AuthState.unauthenticated(),
        );
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  Future<void> _onAuthServerChanged(
    AuthServerChanged event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    await _authRepository.setCurrentServer(event.serverId);

    // Check if we have a user after changing server
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      final token = _authRepository.accessToken;
      emit(AuthState.authenticated(user, token));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout(allSessions: event.allSessions);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final success = await _authRepository.login(
        email: event.email,
        password: event.password,
        deviceInfo: event.deviceInfo,
      );

      if (!success) {
        emit(AuthState.error(_authRepository.lastError ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onAuthSessionUpdated(
    AuthSessionUpdated event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.authenticated && state.user != null) {
      emit(AuthState.authenticated(state.user!, event.token));
    }
  }

  @override
  Future<void> close() {
    _authStatusSubscription?.cancel();
    return super.close();
  }
}
