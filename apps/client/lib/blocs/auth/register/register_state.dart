part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.username = const UsernameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final UsernameInput username;
  final EmailInput email;
  final PasswordInput password;
  final ConfirmPasswordInput confirmPassword;
  final NameInput firstName;
  final NameInput lastName;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  RegisterState copyWith({
    UsernameInput? username,
    EmailInput? email,
    PasswordInput? password,
    ConfirmPasswordInput? confirmPassword,
    NameInput? firstName,
    NameInput? lastName,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    confirmPassword,
    firstName,
    lastName,
    status,
    errorMessage,
  ];
}
