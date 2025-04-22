part of 'session_bloc.dart';

enum SessionStatus { initial, loading, success, failure }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.initial,
    this.sessions = const [],
    this.error,
    this.terminatingSessionId,
    this.isTerminatingAll = false,
    this.terminationSuccess = false,
  });

  final SessionStatus status;
  final List<UserSession> sessions;
  final String? error;
  final String? terminatingSessionId;
  final bool isTerminatingAll;
  final bool terminationSuccess;

  bool get isInitial => status == SessionStatus.initial;
  bool get isLoading => status == SessionStatus.loading;
  bool get isSuccess => status == SessionStatus.success;
  bool get isFailure => status == SessionStatus.failure;
  bool get isEmpty => sessions.isEmpty;

  SessionState copyWith({
    SessionStatus? status,
    List<UserSession>? sessions,
    String? error,
    String? terminatingSessionId,
    bool? isTerminatingAll,
    bool? terminationSuccess,
  }) {
    return SessionState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      error: error,
      terminatingSessionId: terminatingSessionId,
      isTerminatingAll: isTerminatingAll ?? this.isTerminatingAll,
      terminationSuccess: terminationSuccess ?? this.terminationSuccess,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sessions,
    error,
    terminatingSessionId,
    isTerminatingAll,
    terminationSuccess,
  ];
}
