import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../blocs/auth/forgot_password/forgot_password_bloc.dart';
import '../../widgets/ui/custom_text_field.dart';
import '../../router/app_router.dart';

class ForgotPasswordScreenBloc extends StatefulWidget {
  const ForgotPasswordScreenBloc({super.key});

  @override
  State<ForgotPasswordScreenBloc> createState() =>
      _ForgotPasswordScreenBlocState();
}

class _ForgotPasswordScreenBlocState extends State<ForgotPasswordScreenBloc> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    context.read<ForgotPasswordBloc>().add(EmailChanged(_emailController.text));
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(const PasswordResetRequested());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listenWhen:
                (previous, current) =>
                    previous.status != current.status &&
                    (current.status.isFailure || current.status.isSuccess),
            listener: (context, state) {
              if (state.status.isFailure && state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              if (state.status.isSuccess) {
                return _buildSuccessView();
              } else {
                return _buildRequestView(state);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRequestView(ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Reset Your Password',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            buildWhen: (previous, current) => previous.email != current.email,
            builder: (context, state) {
              return CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email address',
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
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSubmit(),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: state.status.isInProgress ? null : _onSubmit,
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
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
        const SizedBox(height: 24),
        Text(
          'Reset Link Sent',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve sent a password reset link to:\n${_emailController.text}',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Please check your email and follow the instructions to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              AppRouter.navigateTo('/login');
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Back to Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
