import 'package:flutter/material.dart';

import 'password_field.dart';

/// Specialized version for confirming passwords
class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return PasswordField(
      controller: controller,
      labelText: 'Confirm Password',
      hintText: 'Confirm your password',
      isConfirmPassword: true,
      originalPassword: passwordController.text,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      enabled: enabled,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
