import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/login/login_bloc.dart';
import '../../router/route_constants.dart';
import '../../models/auth/form_inputs.dart';

import '../../widgets/ui/form/form_button.dart';
import '../../widgets/ui/form/form_container.dart';
import '../../widgets/ui/form/fields/password_field.dart';
import '../../widgets/ui/loading_overlay.dart';
import '../../widgets/auth/social_login_buttons.dart';
import '../../widgets/connectivity/connectivity_status_bar.dart';

class LoginScreen extends StatefulWidget {
  final String? redirectPath;

  const LoginScreen({super.key, this.redirectPath});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    context.read<LoginBloc>().add(LoginEmailChanged(_emailController.text));
  }

  void _onPasswordChanged() {
    context.read<LoginBloc>().add(
      LoginPasswordChanged(_passwordController.text),
    );
  }

  void _onRememberMeChanged(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
    context.read<LoginBloc>().add(LoginRememberMeChanged(_rememberMe));
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<LoginBloc>().add(const LoginSubmitted());
  }

  void _navigateToRegister() {
    context.goNamed(AppRouteNames.register);
  }

  void _navigateToForgotPassword() {
    context.goNamed(AppRouteNames.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectivityStatusBar(
        title: Text(''),
        actions: [],
        showInternetBanner: true,
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listenWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.status.isFailure && state.errorMessage != null) {
            _showErrorSnackBar(state.errorMessage!);
          } else if (state.status.isSuccess) {
            final redirectPath = widget.redirectPath ?? AppRoutes.home;
            context.go(redirectPath);
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.status.isInProgress,
            loadingText: 'Logging in...',
            child: FormContainer(
              title: 'Welcome Back!',
              subtitle: 'Sign in to continue to Board Games Empire',
              headerIcon: Image.asset('images/logo.png', height: 100),
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
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        onChanged: (_) => _onEmailChanged(),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorText:
                              state.email.isPure ? null : _getEmailError(state),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      PasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        onChanged: (_) => _onPasswordChanged(),
                        initiallyObscured: state.password.obscureText,
                        onFieldSubmitted: (_) => _onSubmit(),
                        textInputAction: TextInputAction.done,
                        validator:
                            (_) =>
                                state.password.isPure
                                    ? null
                                    : _getPasswordError(state),
                      ),

                      const SizedBox(height: 16),

                      // Remember me & Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember me checkbox
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: _onRememberMeChanged,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),

                          // Forgot password link
                          TextButton(
                            onPressed: _navigateToForgotPassword,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Login button
                FormButton(
                  text: 'Login',
                  isLoading: state.status.isInProgress,
                  onPressed: _onSubmit,
                ),

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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: const Text(
                        'Sign Up',
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _getEmailError(LoginState state) {
    if (state.email.isPure) return null;

    switch (state.email.error) {
      case EmailValidationError.empty:
        return 'Email cannot be empty';
      case EmailValidationError.invalid:
        return 'Please enter a valid email';
      default:
        return null;
    }
  }

  String? _getPasswordError(LoginState state) {
    if (state.password.isPure) return null;

    switch (state.password.error) {
      case PasswordValidationError.empty:
        return 'Password cannot be empty';
      case PasswordValidationError.invalid:
        return 'Password must be at least 8 characters';
      default:
        return null;
    }
  }
}
