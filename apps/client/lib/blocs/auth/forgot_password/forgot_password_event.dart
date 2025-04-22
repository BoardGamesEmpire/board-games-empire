part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordResetRequested extends ForgotPasswordEvent {
  const PasswordResetRequested();
}

class ResetFormState extends ForgotPasswordEvent {
  const ResetFormState();
}
