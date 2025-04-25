import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'error_event.dart';
part 'error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorState()) {
    on<ErrorReported>(_onErrorReported);
    on<ErrorDismissed>(_onErrorDismissed);
    on<NetworkErrorReported>(_onNetworkErrorReported);
    on<AuthErrorReported>(_onAuthErrorReported);
    on<ServerErrorReported>(_onServerErrorReported);
  }

  void _onErrorReported(ErrorReported event, Emitter<ErrorState> emit) {
    emit(
      state.copyWith(
        hasError: true,
        message: event.message,
        errorType: ErrorType.generic,
        showDialog: event.shouldShowDialog,
      ),
    );
  }

  void _onNetworkErrorReported(
    NetworkErrorReported event,
    Emitter<ErrorState> emit,
  ) {
    emit(
      state.copyWith(
        hasError: true,
        message: event.message,
        errorType: ErrorType.network,
        showDialog: event.shouldShowDialog,
      ),
    );
  }

  void _onAuthErrorReported(AuthErrorReported event, Emitter<ErrorState> emit) {
    emit(
      state.copyWith(
        hasError: true,
        message: event.message,
        errorType: ErrorType.auth,
        showDialog: event.shouldShowDialog,
      ),
    );
  }

  void _onServerErrorReported(
    ServerErrorReported event,
    Emitter<ErrorState> emit,
  ) {
    emit(
      state.copyWith(
        hasError: true,
        message: event.message,
        errorType: ErrorType.server,
        showDialog: event.shouldShowDialog,
      ),
    );
  }

  void _onErrorDismissed(ErrorDismissed event, Emitter<ErrorState> emit) {
    emit(state.copyWith(hasError: false, message: null, showDialog: false));
  }
}
