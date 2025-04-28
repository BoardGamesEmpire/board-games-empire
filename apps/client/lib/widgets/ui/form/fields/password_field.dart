import 'package:flutter/material.dart';

/// A reusable password field widget with show/hide functionality and validation.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  final String labelText;

  final String hintText;

  final void Function(String)? onChanged;

  final String? Function(String?)? validator;

  final bool isConfirmPassword;

  final String? originalPassword;

  final void Function(String)? onFieldSubmitted;

  final TextInputAction textInputAction;

  final bool initiallyObscured;

  final bool enabled;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.onChanged,
    this.validator,
    this.isConfirmPassword = false,
    this.originalPassword,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.initiallyObscured = true,
    this.enabled = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initiallyObscured;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: widget.validator ?? _defaultValidator,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (widget.isConfirmPassword && widget.originalPassword != null) {
      if (value != widget.originalPassword) {
        return 'Passwords do not match';
      }
    }

    return null;
  }
}
