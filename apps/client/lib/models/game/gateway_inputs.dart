import 'package:formz/formz.dart';

/// Input validation for game gateway name
class SourceNameInput extends FormzInput<String, String> {
  const SourceNameInput.pure() : super.pure('');
  const SourceNameInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }
}

/// Input validation for URL fields
class UrlInput extends FormzInput<String, String> {
  const UrlInput.pure() : super.pure('');
  const UrlInput.dirty([super.value = '']) : super.dirty();

  static final _urlRegExp = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return null; // URL can be empty
    }

    if (!_urlRegExp.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }
}

/// Input validation for API version
class ApiVersionInput extends FormzInput<String, String> {
  const ApiVersionInput.pure() : super.pure('');
  const ApiVersionInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    return null;
  }
}

/// Input validation for API key name
class ApiKeyNameInput extends FormzInput<String, String> {
  const ApiKeyNameInput.pure() : super.pure('');
  const ApiKeyNameInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'API key name is required';
    }
    return null;
  }
}

/// Input validation for API key value
class ApiKeyValueInput extends FormzInput<String, String> {
  const ApiKeyValueInput.pure() : super.pure('');
  const ApiKeyValueInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'API key value is required';
    }
    return null;
  }
}

/// Input validation for username
class UsernameInput extends FormzInput<String, String> {
  const UsernameInput.pure() : super.pure('');
  const UsernameInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }
}

/// Input validation for password
class PasswordInput extends FormzInput<String, String> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}

/// Input validation for OAuth client ID
class ClientIdInput extends FormzInput<String, String> {
  const ClientIdInput.pure() : super.pure('');
  const ClientIdInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Client ID is required';
    }
    return null;
  }
}

/// Input validation for OAuth client secret
class ClientSecretInput extends FormzInput<String, String> {
  const ClientSecretInput.pure() : super.pure('');
  const ClientSecretInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Client secret is required';
    }
    return null;
  }
}

/// Input validation for PSK (Pre-shared key)
class PskInput extends FormzInput<String, String> {
  const PskInput.pure() : super.pure('');
  const PskInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'Pre-shared key is required';
    }
    return null;
  }
}
