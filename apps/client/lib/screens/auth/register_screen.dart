import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/register/register_bloc.dart';
import '../../router/app_router.dart';
import '../../router/route_constants.dart';
import '../../widgets/ui/custom_text_field.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(const RegisterSubmitted());
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
      appBar: AppBar(title: const Text('Create Account'), elevation: 0),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            _showSuccessDialog();
          } else if (state.status.isFailure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) =>
                            previous.username != current.username,
                    builder: (context, state) {
                      return CustomTextField(
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
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) => previous.email != current.email,
                    builder: (context, state) {
                      return CustomTextField(
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
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) =>
                            previous.firstName != current.firstName,
                    builder: (context, state) {
                      return CustomTextField(
                        controller: _firstNameController,
                        labelText: 'First Name (Optional)',
                        hintText: 'Enter your first name',
                        prefixIcon: Icons.person_outline,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) =>
                            previous.lastName != current.lastName,
                    builder: (context, state) {
                      return CustomTextField(
                        controller: _lastNameController,
                        labelText: 'Last Name (Optional)',
                        hintText: 'Enter your last name',
                        prefixIcon: Icons.person_outline,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) =>
                            previous.password != current.password,
                    builder: (context, state) {
                      return CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Create a password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) =>
                            previous.confirmPassword !=
                                current.confirmPassword ||
                            previous.password != current.password,
                    builder: (context, state) {
                      return CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onSubmit(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    buildWhen:
                        (previous, current) =>
                            previous.status != current.status,
                    builder: (context, state) {
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              state.status.isInProgress ? null : _onSubmit,
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'By clicking Create Account, you agree to our Terms of Service and Privacy Policy.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

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
            ),
          ),
        ),
      ),
    );
  }
}
