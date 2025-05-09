import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../models/auth/form_inputs.dart';
import '../../../repositories/auth/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterFirstNameChanged>(_onFirstNameChanged);
    on<RegisterLastNameChanged>(_onLastNameChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final username = UsernameInput.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status:
            Formz.validate([
                  username,
                  state.email,
                  state.password,
                  state.confirmPassword,
                  state.firstName,
                  state.lastName,
                ])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status:
            Formz.validate([
                  state.username,
                  email,
                  state.password,
                  state.confirmPassword,
                  state.firstName,
                  state.lastName,
                ])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
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
            Formz.validate([
                  state.username,
                  state.email,
                  password,
                  confirmPassword,
                  state.firstName,
                  state.lastName,
                ])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status:
            Formz.validate([
                  state.username,
                  state.email,
                  state.password,
                  confirmPassword,
                  state.firstName,
                  state.lastName,
                ])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onFirstNameChanged(
    RegisterFirstNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final firstName = NameInput.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        status:
            Formz.validate([
                  state.username,
                  state.email,
                  state.password,
                  state.confirmPassword,
                  firstName,
                  state.lastName,
                ])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  void _onLastNameChanged(
    RegisterLastNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final lastName = NameInput.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        status:
            Formz.validate([
                  state.username,
                  state.email,
                  state.password,
                  state.confirmPassword,
                  state.firstName,
                  lastName,
                ])
                ? FormzSubmissionStatus.initial
                : FormzSubmissionStatus.failure,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (Formz.validate([
      state.username,
      state.email,
      state.password,
      state.confirmPassword,
      state.firstName,
      state.lastName,
    ])) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final success = await _authRepository.register(
          username: state.username.value,
          email: state.email.value,
          password: state.password.value,
          firstName:
              state.firstName.value.isNotEmpty ? state.firstName.value : null,
          lastName:
              state.lastName.value.isNotEmpty ? state.lastName.value : null,
        );

        if (success) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: _authRepository.lastError ?? 'Registration failed',
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
          errorMessage: 'Please correct the errors in the form',
        ),
      );
    }
  }
}
