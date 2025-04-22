import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user.dart';
import '../../../repositories/auth/auth_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final AuthRepository _authRepository;

  SessionBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SessionState()) {
    on<SessionsRequested>(_onSessionsRequested);
    on<SessionTerminated>(_onSessionTerminated);
    on<AllSessionsTerminated>(_onAllSessionsTerminated);
    on<SessionRefreshed>(_onSessionRefreshed);
  }

  Future<void> _onSessionsRequested(
    SessionsRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(status: SessionStatus.loading));

    try {
      final sessions = await _authRepository.getActiveSessions();

      emit(
        state.copyWith(
          status: SessionStatus.success,
          sessions: sessions,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SessionStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSessionTerminated(
    SessionTerminated event,
    Emitter<SessionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SessionStatus.loading,
        terminatingSessionId: event.sessionId,
      ),
    );

    try {
      final success = await _authRepository.logoutSession(event.sessionId);

      if (success) {
        // If the terminated session is the current session, don't modify the state
        // as the user will be redirected to login
        if (!event.isCurrentSession) {
          final updatedSessions =
              state.sessions
                  .where((session) => session.id != event.sessionId)
                  .toList();

          emit(
            state.copyWith(
              status: SessionStatus.success,
              sessions: updatedSessions,
              terminatingSessionId: null,
              terminationSuccess: true,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: SessionStatus.failure,
            error: 'Failed to terminate session',
            terminatingSessionId: null,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SessionStatus.failure,
          error: 'Error terminating session: ${e.toString()}',
          terminatingSessionId: null,
        ),
      );
    }
  }

  Future<void> _onAllSessionsTerminated(
    AllSessionsTerminated event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(status: SessionStatus.loading, isTerminatingAll: true));

    try {
      // We don't need to update the state here as the user will be redirected to login
      await _authRepository.logout(allSessions: true);
    } catch (e) {
      emit(
        state.copyWith(
          status: SessionStatus.failure,
          error: 'Error terminating all sessions: ${e.toString()}',
          isTerminatingAll: false,
        ),
      );
    }
  }

  Future<void> _onSessionRefreshed(
    SessionRefreshed event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(terminationSuccess: false));

    add(const SessionsRequested());
  }
}
