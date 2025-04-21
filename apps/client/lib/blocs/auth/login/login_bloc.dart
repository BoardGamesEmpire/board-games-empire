import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../models/auth/form_inputs.dart';
import '../../../repositories/auth/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginRememberMeChanged>(_onRememberMeChanged);
    on<LoginTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status:
            Formz.validate([email, state.password])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status:
            Formz.validate([state.email, password])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onRememberMeChanged(
    LoginRememberMeChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.value));
  }

  void _onTogglePasswordVisibility(
    LoginTogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    final updatedPassword = state.password.copyWith(
      obscureText: !state.password.obscureText,
    );
    emit(state.copyWith(password: updatedPassword));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (Formz.validate([state.email, state.password])) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final deviceInfo = await _authRepository.getDeviceInfo();
        final success = await _authRepository.login(
          email: state.email.value,
          password: state.password.value,
          deviceInfo: deviceInfo,
          rememberMe: state.rememberMe,
        );

        if (success) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: _authRepository.lastError ?? 'Login failed',
            ),
          );
        }
      } catch (error) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: error.toString(),
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Please enter valid email and password',
        ),
      );
    }
  }
}
