part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionsRequested extends SessionEvent {
  const SessionsRequested();
}

class SessionTerminated extends SessionEvent {
  const SessionTerminated(this.sessionId, {this.isCurrentSession = false});

  final String sessionId;
  final bool isCurrentSession;

  @override
  List<Object> get props => [sessionId, isCurrentSession];
}

class AllSessionsTerminated extends SessionEvent {
  const AllSessionsTerminated();
}

class SessionRefreshed extends SessionEvent {
  const SessionRefreshed();
}
