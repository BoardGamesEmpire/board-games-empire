import 'package:flutter/material.dart';

/// A reusable widget for displaying error states and retry actions.
class ErrorDisplay extends StatelessWidget {
  final String message;

  final IconData icon;

  final VoidCallback? onRetry;

  final String? title;

  final double iconSize;

  final Color? iconColor;

  final bool showRetryButton;

  final String retryButtonText;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.title,
    this.iconSize = 64,
    this.iconColor,
    this.showRetryButton = true,
    this.retryButtonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? Colors.red;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: effectiveIconColor),
            const SizedBox(height: 24),

            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Factory constructor for creating a network error display
  factory ErrorDisplay.network({
    required String message,
    VoidCallback? onRetry,
    String? title,
  }) {
    return ErrorDisplay(
      message: message,
      title: title ?? 'Network Error',
      icon: Icons.wifi_off,
      iconColor: Colors.orange,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for creating a server error display
  factory ErrorDisplay.server({
    required String message,
    VoidCallback? onRetry,
    String? title,
  }) {
    return ErrorDisplay(
      message: message,
      title: title ?? 'Server Error',
      icon: Icons.dns,
      iconColor: Colors.purple,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for creating an empty state display
  factory ErrorDisplay.empty({
    required String message,
    String? title,
    IconData icon = Icons.inbox,
    Color iconColor = Colors.grey,
    bool showRetryButton = false,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return ErrorDisplay(
      message: message,
      title: title,
      icon: icon,
      iconColor: iconColor,
      showRetryButton: showRetryButton && onAction != null,
      onRetry: onAction,
      retryButtonText: actionLabel ?? 'Refresh',
    );
  }
}
