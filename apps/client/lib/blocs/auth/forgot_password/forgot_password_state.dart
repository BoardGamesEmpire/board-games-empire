part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = const EmailInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final EmailInput email;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  ForgotPasswordState copyWith({
    EmailInput? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage];
}
