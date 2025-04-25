part of 'error_bloc.dart';

abstract class ErrorEvent extends Equatable {
  const ErrorEvent();

  @override
  List<Object?> get props => [];
}

class ErrorReported extends ErrorEvent {
  final String message;
  final bool shouldShowDialog;

  const ErrorReported(this.message, {this.shouldShowDialog = false});

  @override
  List<Object> get props => [message, shouldShowDialog];
}

class NetworkErrorReported extends ErrorEvent {
  final String message;
  final bool shouldShowDialog;

  const NetworkErrorReported(this.message, {this.shouldShowDialog = false});

  @override
  List<Object> get props => [message, shouldShowDialog];
}

class AuthErrorReported extends ErrorEvent {
  final String message;
  final bool shouldShowDialog;

  const AuthErrorReported(this.message, {this.shouldShowDialog = false});

  @override
  List<Object> get props => [message, shouldShowDialog];
}

class ServerErrorReported extends ErrorEvent {
  final String message;
  final bool shouldShowDialog;

  const ServerErrorReported(this.message, {this.shouldShowDialog = false});

  @override
  List<Object> get props => [message, shouldShowDialog];
}

class ErrorDismissed extends ErrorEvent {
  const ErrorDismissed();
}
