import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/register/register_bloc.dart';
import '../../router/app_router.dart';
import '../../router/route_constants.dart';
import '../../widgets/ui/form/form_button.dart';
import '../../widgets/ui/form/form_container.dart';
import '../../widgets/ui/form/fields/password_field.dart';
import '../../widgets/ui/form/fields/password_confirmation_field.dart';
import '../../widgets/ui/custom_text_field.dart';
import '../../widgets/connectivity/connectivity_status_bar.dart';
import '../../widgets/ui/loading_overlay.dart';
import '../../widgets/auth/social_login_buttons.dart';

class RegisterScreenBloc extends StatefulWidget {
  const RegisterScreenBloc({super.key});

  @override
  State<RegisterScreenBloc> createState() => _RegisterScreenBlocState();
}

class _RegisterScreenBlocState extends State<RegisterScreenBloc> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupTextControllerListeners();
  }

  void _setupTextControllerListeners() {
    _usernameController.addListener(_onUsernameChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  void _onUsernameChanged() {
    context.read<RegisterBloc>().add(
      RegisterUsernameChanged(_usernameController.text),
    );
  }

  void _onEmailChanged() {
    context.read<RegisterBloc>().add(
      RegisterEmailChanged(_emailController.text),
    );
  }

  void _onPasswordChanged() {
    context.read<RegisterBloc>().add(
      RegisterPasswordChanged(_passwordController.text),
    );
  }

  void _onConfirmPasswordChanged() {
    context.read<RegisterBloc>().add(
      RegisterConfirmPasswordChanged(_confirmPasswordController.text),
    );
  }

  void _onFirstNameChanged() {
    context.read<RegisterBloc>().add(
      RegisterFirstNameChanged(_firstNameController.text),
    );
  }

  void _onLastNameChanged() {
    context.read<RegisterBloc>().add(
      RegisterLastNameChanged(_lastNameController.text),
    );
  }

  void _onSubmit() {
    // First validate the form using Flutter's validation
    if (_formKey.currentState!.validate()) {
      // Only if form validation passes, submit the registration request
      context.read<RegisterBloc>().add(const RegisterSubmitted());
      // Don't show the success dialog here - it will be shown when the bloc emits success state
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text(
              'Your account has been created successfully. Please check your email for verification.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  AppRouter.navigateTo(AppRoutes.login);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectivityStatusBar(
        title: Text('Create Account'),
        elevation: 0,
      ),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listenWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          // Only show success dialog when registration is ACTUALLY successful from the server
          // FormzSubmissionStatus.success is returned from the repository after successful API response
          if (state.status == FormzSubmissionStatus.success) {
            _showSuccessDialog();
          } else if (state.status == FormzSubmissionStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.status.isInProgress,
            loadingText: 'Creating account...',
            child: FormContainer(
              title: 'Create Your Account',
              subtitle:
                  'Join Board Games Empire to connect with other board game enthusiasts',
              children: [
                if (state.errorMessage != null && state.status.isFailure)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username field
                      CustomTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                        hintText: 'Choose a username',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Email field
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // First Name field
                      CustomTextField(
                        controller: _firstNameController,
                        labelText: 'First Name (Optional)',
                        hintText: 'Enter your first name',
                        prefixIcon: Icons.person_outline,
                      ),

                      const SizedBox(height: 16),

                      // Last Name field
                      CustomTextField(
                        controller: _lastNameController,
                        labelText: 'Last Name (Optional)',
                        hintText: 'Enter your last name',
                        prefixIcon: Icons.person_outline,
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Create a password',
                        onChanged: (_) => _onPasswordChanged(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          // Check for at least one number
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          // Check for at least one special character
                          if (!RegExp(
                            r'[!@#$%^&*(),.?":{}|<>]',
                          ).hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password field
                      ConfirmPasswordField(
                        controller: _confirmPasswordController,
                        passwordController: _passwordController,
                        onChanged: (_) => _onConfirmPasswordChanged(),
                        onFieldSubmitted: (_) => _onSubmit(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Create Account button
                FormButton(
                  text: 'Create Account',
                  isLoading: state.status.isInProgress,
                  onPressed: _onSubmit,
                ),

                const SizedBox(height: 16),

                Text(
                  'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 16),

                // Social login buttons
                SocialLoginButtons(
                  onGoogleLogin: () {
                    // TODO: Implement social login
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Google login not implemented yet'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => AppRouter.navigateTo(AppRoutes.login),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
