import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/auth/login/login_bloc.dart';
import '../../widgets/auth/social_login_buttons.dart';
import '../../router/app_router.dart';
import '../../router/route_constants.dart';
import '../../models/auth/form_inputs.dart';

class LoginScreenBloc extends StatefulWidget {
  final String? redirectPath;

  const LoginScreenBloc({super.key, this.redirectPath});

  @override
  State<LoginScreenBloc> createState() => _LoginScreenBlocState();
}

class _LoginScreenBlocState extends State<LoginScreenBloc> {
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToRegister() {
    AppRouter.navigateTo(AppRoutes.register);
  }

  void _navigateToForgotPassword() {
    AppRouter.navigateTo(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isFailure && state.errorMessage != null) {
              _showErrorSnackBar(state.errorMessage!);
            } else if (state.status.isSuccess) {
              final redirectPath = widget.redirectPath ?? AppRoutes.home;
              AppRouter.replaceTo(redirectPath);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or App name
                  const SizedBox(height: 16),
                  Image.asset('images/logo.png', height: 100),
                  const SizedBox(height: 32),

                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue to Board Games Empire',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen:
                        (previous, current) =>
                            previous.status != current.status,
                    builder: (context, state) {
                      return Form(
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
                                    state.email.isPure
                                        ? null
                                        : _getEmailError(state),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              onChanged: (_) => _onPasswordChanged(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorText:
                                    state.password.isPure
                                        ? null
                                        : _getPasswordError(state),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.password.obscureText
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<LoginBloc>().add(
                                      const LoginTogglePasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                              obscureText: state.password.obscureText,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _onSubmit(),
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    state.status.isInProgress
                                        ? null
                                        : _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    state.status.isInProgress
                                        ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                        : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

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
                  const SizedBox(height: 24),

                  // TODO: retrieve social login options from server
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
                  const SizedBox(height: 32),

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
            ),
          ),
        ),
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
