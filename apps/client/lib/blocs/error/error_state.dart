part of 'error_bloc.dart';

enum ErrorType { generic, network, auth, server }

class ErrorState extends Equatable {
  final bool hasError;
  final String? message;
  final ErrorType errorType;
  final bool showDialog;

  const ErrorState({
    this.hasError = false,
    this.message,
    this.errorType = ErrorType.generic,
    this.showDialog = false,
  });

  ErrorState copyWith({
    bool? hasError,
    String? message,
    ErrorType? errorType,
    bool? showDialog,
  }) {
    return ErrorState(
      hasError: hasError ?? this.hasError,
      message: message ?? this.message,
      errorType: errorType ?? this.errorType,
      showDialog: showDialog ?? this.showDialog,
    );
  }

  @override
  List<Object?> get props => [hasError, message, errorType, showDialog];
}
