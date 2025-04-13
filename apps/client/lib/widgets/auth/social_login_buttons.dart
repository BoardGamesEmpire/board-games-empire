import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback? onAppleLogin;

  const SocialLoginButtons({
    super.key,
    required this.onGoogleLogin,
    this.onAppleLogin,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Google login button
        _SocialButton(
          onPressed: onGoogleLogin,
          text: 'Continue with Google',
          icon: 'assets/icons/google.png',
          backgroundColor: isDarkMode ? Colors.white10 : Colors.white,
          textColor: isDarkMode ? Colors.white : Colors.black87,
          borderColor: isDarkMode ? Colors.white24 : Colors.black12,
        ),

        if (onAppleLogin != null) ...[
          const SizedBox(height: 12),
          // Apple login button
          _SocialButton(
            onPressed: onAppleLogin!,
            text: 'Continue with Apple',
            icon: 'assets/icons/apple.png',
            backgroundColor: isDarkMode ? Colors.white : Colors.black,
            textColor: isDarkMode ? Colors.black : Colors.white,
            borderColor: Colors.transparent,
          ),
        ],
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _SocialButton({
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
