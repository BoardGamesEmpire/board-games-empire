import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

enum PasswordValidationError { empty, invalid }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  final bool obscureText;

  const PasswordInput.pure() : obscureText = true, super.pure('');

  const PasswordInput.dirty([super.value = ''])
    : obscureText = true,
      super.dirty();

  const PasswordInput.dirtyWithVisibility({
    required String value,
    required this.obscureText,
  }) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < 8) return PasswordValidationError.invalid;
    return null;
  }

  PasswordInput copyWith({String? value, bool? obscureText}) {
    return PasswordInput.dirtyWithVisibility(
      value: value ?? this.value,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}

enum UsernameValidationError { empty, invalid }

class UsernameInput extends FormzInput<String, UsernameValidationError> {
  const UsernameInput.pure() : super.pure('');
  const UsernameInput.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    if (value.length < 3) return UsernameValidationError.invalid;
    return null;
  }
}

enum ConfirmPasswordValidationError { empty, mismatch }

class ConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPasswordInput.pure({this.password = ''}) : super.pure('');
  const ConfirmPasswordInput.dirty({required this.password, String value = ''})
    : super.dirty(value);

  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;
    return password == value ? null : ConfirmPasswordValidationError.mismatch;
  }
}

enum UrlValidationError { empty, invalid }

class UrlInput extends FormzInput<String, UrlValidationError> {
  const UrlInput.pure() : super.pure('');
  const UrlInput.dirty([super.value = '']) : super.dirty();

  @override
  UrlValidationError? validator(String value) {
    if (value.isEmpty) return UrlValidationError.empty;

    try {
      String url = value.trim();
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      Uri.parse(url);
      return null;
    } catch (_) {
      return UrlValidationError.invalid;
    }
  }
}

enum NameValidationError { invalid }

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.isNotEmpty && value.length < 2) {
      return NameValidationError.invalid;
    }

    return null;
  }
}
