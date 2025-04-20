part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.rememberMe = false,
    this.errorMessage,
  });

  final EmailInput email;
  final PasswordInput password;
  final FormzSubmissionStatus status;
  final bool rememberMe;
  final String? errorMessage;

  LoginState copyWith({
    EmailInput? email,
    PasswordInput? password,
    FormzSubmissionStatus? status,
    bool? rememberMe,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    rememberMe,
    errorMessage,
  ];
}
