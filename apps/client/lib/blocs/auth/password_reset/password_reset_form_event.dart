part of 'password_reset_form_bloc.dart';

abstract class PasswordResetFormEvent extends Equatable {
  const PasswordResetFormEvent();

  @override
  List<Object> get props => [];
}

class TokenChanged extends PasswordResetFormEvent {
  final String token;

  const TokenChanged(this.token);

  @override
  List<Object> get props => [token];
}

class NewPasswordChanged extends PasswordResetFormEvent {
  final String password;

  const NewPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends PasswordResetFormEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class PasswordResetSubmitted extends PasswordResetFormEvent {
  const PasswordResetSubmitted();
}

class ResetTokenInput extends FormzInput<String, String> {
  const ResetTokenInput.pure() : super.pure('');
  const ResetTokenInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) return 'Token cannot be empty';
    if (value.length < 10) return 'Invalid token format';
    return null;
  }
}
