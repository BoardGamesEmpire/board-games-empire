import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../models/auth/form_inputs.dart';
import '../../../models/user.dart';
import '../../../repositories/auth/auth_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthRepository _authRepository;

  AccountBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AccountState()) {
    on<AccountInitialized>(_onInitialized);
    on<UserDataUpdated>(_onUserDataUpdated);
    on<AccountNameChanged>(_onNameChanged);
    on<AccountEmailChanged>(_onEmailChanged);
    on<AccountUsernameChanged>(_onUsernameChanged);
    on<AccountPasswordChanged>(_onPasswordChanged);
    on<AccountCurrentPasswordChanged>(_onCurrentPasswordChanged);
    on<AccountPasswordChangeRequested>(_onPasswordChangeRequested);
    on<AccountProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  Future<void> _onInitialized(
    AccountInitialized event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            user: user,
            username: UsernameInput.dirty(user.username),
            email: EmailInput.dirty(user.email),
            firstName: NameInput.dirty(user.firstName ?? ''),
            lastName: NameInput.dirty(user.lastName ?? ''),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            error: 'User not found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _onUserDataUpdated(UserDataUpdated event, Emitter<AccountState> emit) {
    emit(
      state.copyWith(
        user: event.user,
        username: UsernameInput.dirty(event.user.username),
        email: EmailInput.dirty(event.user.email),
        firstName: NameInput.dirty(event.user.firstName ?? ''),
        lastName: NameInput.dirty(event.user.lastName ?? ''),
      ),
    );
  }

  void _onNameChanged(AccountNameChanged event, Emitter<AccountState> emit) {
    final firstName = NameInput.dirty(event.firstName);
    final lastName = NameInput.dirty(event.lastName);

    emit(
      state.copyWith(
        firstName: firstName,
        lastName: lastName,
        isProfileFormValid: Formz.validate([
          firstName,
          lastName,
          state.username,
          state.email,
        ]),
      ),
    );
  }

  void _onEmailChanged(AccountEmailChanged event, Emitter<AccountState> emit) {
    final email = EmailInput.dirty(event.email);

    emit(
      state.copyWith(
        email: email,
        isProfileFormValid: Formz.validate([
          state.firstName,
          state.lastName,
          state.username,
          email,
        ]),
      ),
    );
  }

  void _onUsernameChanged(
    AccountUsernameChanged event,
    Emitter<AccountState> emit,
  ) {
    final username = UsernameInput.dirty(event.username);

    emit(
      state.copyWith(
        username: username,
        isProfileFormValid: Formz.validate([
          state.firstName,
          state.lastName,
          username,
          state.email,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    AccountPasswordChanged event,
    Emitter<AccountState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    final confirmPassword = ConfirmPasswordInput.dirty(
      password: event.password,
      value: state.confirmPassword.value,
    );

    emit(
      state.copyWith(
        newPassword: password,
        confirmPassword: confirmPassword,
        isPasswordFormValid: Formz.validate([
          state.currentPassword,
          password,
          confirmPassword,
        ]),
      ),
    );
  }

  void _onCurrentPasswordChanged(
    AccountCurrentPasswordChanged event,
    Emitter<AccountState> emit,
  ) {
    final currentPassword = PasswordInput.dirty(event.password);

    emit(
      state.copyWith(
        currentPassword: currentPassword,
        isPasswordFormValid: Formz.validate([
          currentPassword,
          state.newPassword,
          state.confirmPassword,
        ]),
      ),
    );
  }

  Future<void> _onPasswordChangeRequested(
    AccountPasswordChangeRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.isPasswordFormValid) {
      emit(
        state.copyWith(
          passwordStatus: FormzSubmissionStatus.failure,
          passwordError: 'Please correct the errors in the form',
        ),
      );
      return;
    }

    emit(state.copyWith(passwordStatus: FormzSubmissionStatus.inProgress));

    try {
      final success = await _authRepository.changePassword(
        state.currentPassword.value,
        state.newPassword.value,
      );

      if (success) {
        emit(
          state.copyWith(
            passwordStatus: FormzSubmissionStatus.success,
            passwordError: null,
            currentPassword: const PasswordInput.pure(),
            newPassword: const PasswordInput.pure(),
            confirmPassword: const ConfirmPasswordInput.pure(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            passwordStatus: FormzSubmissionStatus.failure,
            passwordError:
                _authRepository.lastError ?? 'Failed to change password',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          passwordStatus: FormzSubmissionStatus.failure,
          passwordError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onProfileUpdateRequested(
    AccountProfileUpdateRequested event,
    Emitter<AccountState> emit,
  ) async {
    if (!state.isProfileFormValid) {
      emit(
        state.copyWith(
          profileStatus: FormzSubmissionStatus.failure,
          error: 'Please correct the errors in the form',
        ),
      );
      return;
    }

    emit(state.copyWith(profileStatus: FormzSubmissionStatus.inProgress));

    try {
      final updatedUser = await _authRepository.updateProfile(
        username: state.username.value,
        email: state.email.value,
        firstName:
            state.firstName.value.isNotEmpty ? state.firstName.value : null,
        lastName: state.lastName.value.isNotEmpty ? state.lastName.value : null,
      );

      if (updatedUser != null) {
        emit(
          state.copyWith(
            user: updatedUser,
            profileStatus: FormzSubmissionStatus.success,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            profileStatus: FormzSubmissionStatus.failure,
            error: _authRepository.lastError ?? 'Failed to update profile',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: FormzSubmissionStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
