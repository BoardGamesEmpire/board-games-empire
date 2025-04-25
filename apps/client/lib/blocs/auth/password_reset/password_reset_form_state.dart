part of 'password_reset_form_bloc.dart';

class PasswordResetFormState extends Equatable {
  final ResetTokenInput token;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const PasswordResetFormState({
    this.token = const ResetTokenInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  PasswordResetFormState copyWith({
    ResetTokenInput? token,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return PasswordResetFormState(
      token: token ?? this.token,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    token,
    password,
    confirmPassword,
    status,
    errorMessage,
  ];
}
