part of 'account_bloc.dart';

class AccountState extends Equatable {
  final User? user;
  final UsernameInput username;
  final EmailInput email;
  final NameInput firstName;
  final NameInput lastName;
  final PasswordInput currentPassword;
  final PasswordInput newPassword;
  final ConfirmPasswordInput confirmPassword;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus profileStatus;
  final FormzSubmissionStatus passwordStatus;
  final String? error;
  final String? passwordError;
  final bool isProfileFormValid;
  final bool isPasswordFormValid;

  const AccountState({
    this.user,
    this.username = const UsernameInput.pure(),
    this.email = const EmailInput.pure(),
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.currentPassword = const PasswordInput.pure(),
    this.newPassword = const PasswordInput.pure(),
    this.confirmPassword = const ConfirmPasswordInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.profileStatus = FormzSubmissionStatus.initial,
    this.passwordStatus = FormzSubmissionStatus.initial,
    this.error,
    this.passwordError,
    this.isProfileFormValid = false,
    this.isPasswordFormValid = false,
  });

  AccountState copyWith({
    User? user,
    UsernameInput? username,
    EmailInput? email,
    NameInput? firstName,
    NameInput? lastName,
    PasswordInput? currentPassword,
    PasswordInput? newPassword,
    ConfirmPasswordInput? confirmPassword,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? profileStatus,
    FormzSubmissionStatus? passwordStatus,
    String? error,
    String? passwordError,
    bool? isProfileFormValid,
    bool? isPasswordFormValid,
  }) {
    return AccountState(
      user: user ?? this.user,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      profileStatus: profileStatus ?? this.profileStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      error: error,
      passwordError: passwordError,
      isProfileFormValid: isProfileFormValid ?? this.isProfileFormValid,
      isPasswordFormValid: isPasswordFormValid ?? this.isPasswordFormValid,
    );
  }

  @override
  List<Object?> get props => [
    user,
    username,
    email,
    firstName,
    lastName,
    currentPassword,
    newPassword,
    confirmPassword,
    status,
    profileStatus,
    passwordStatus,
    error,
    passwordError,
    isProfileFormValid,
    isPasswordFormValid,
  ];
}
