import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/auth/form_inputs.dart';
import '../../../repositories/auth/auth_repository.dart';

part 'password_reset_form_event.dart';
part 'password_reset_form_state.dart';

class PasswordResetFormBloc
    extends Bloc<PasswordResetFormEvent, PasswordResetFormState> {
  final AuthRepository _authRepository;

  PasswordResetFormBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const PasswordResetFormState()) {
    on<TokenChanged>(_onTokenChanged);
    on<NewPasswordChanged>(_onNewPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordResetSubmitted>(_onSubmitted);
  }

  void _onTokenChanged(
    TokenChanged event,
    Emitter<PasswordResetFormState> emit,
  ) {
    final token = ResetTokenInput.dirty(event.token);
    emit(
      state.copyWith(
        token: token,
        status:
            Formz.validate([token, state.password, state.confirmPassword])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onNewPasswordChanged(
    NewPasswordChanged event,
    Emitter<PasswordResetFormState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: event.password,
      value: state.confirmPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirmPassword,
        status:
            Formz.validate([state.token, password, confirmPassword])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<PasswordResetFormState> emit,
  ) {
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status:
            Formz.validate([state.token, state.password, confirmPassword])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  Future<void> _onSubmitted(
    PasswordResetSubmitted event,
    Emitter<PasswordResetFormState> emit,
  ) async {
    if (state.status.isInProgress) return;

    if (!Formz.validate([state.token, state.password, state.confirmPassword])) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Please fill all fields correctly',
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final success = await _authRepository.resetPassword(
        state.token.value,
        state.password.value,
      );

      if (success) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage:
                _authRepository.lastError ?? 'Failed to reset password',
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
}
