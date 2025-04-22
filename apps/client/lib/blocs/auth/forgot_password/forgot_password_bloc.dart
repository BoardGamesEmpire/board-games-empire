import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../models/auth/form_inputs.dart';
import '../../../repositories/auth/auth_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<ResetFormState>(_onResetFormState);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status:
            Formz.validate([email])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (!Formz.validate([state.email])) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Please enter a valid email address',
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final success = await _authRepository.requestPasswordReset(
        state.email.value,
      );

      if (success) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage:
                _authRepository.lastError ?? 'Failed to send reset email',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetFormState(
    ResetFormState event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(const ForgotPasswordState());
  }
}
