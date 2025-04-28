import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A reusable confirmation dialog with customizable content, actions, and styling.
class ConfirmationDialog extends StatelessWidget {
  final String title;

  final String message;

  final String confirmText;

  final String cancelText;

  final VoidCallback onConfirm;

  final VoidCallback? onCancel;

  final Color? confirmColor;

  final IconData? icon;

  final Color? iconColor;

  final bool isDestructiveAction;

  final bool barrierDismissible;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.iconColor,
    this.isDestructiveAction = false,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveConfirmColor =
        confirmColor ?? (isDestructiveAction ? Colors.red : theme.primaryColor);

    return AlertDialog(
      title:
          icon != null
              ? Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title)),
                ],
              )
              : Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => context.pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            context.pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveConfirmColor,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show the confirmation dialog and return the result (true if confirmed, false otherwise)
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
    Color? iconColor,
    bool isDestructiveAction = false,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => ConfirmationDialog(
            title: title,
            message: message,
            onConfirm: onConfirm,
            confirmText: confirmText,
            cancelText: cancelText,
            onCancel: onCancel,
            confirmColor: confirmColor,
            icon: icon,
            iconColor: iconColor,
            isDestructiveAction: isDestructiveAction,
            barrierDismissible: barrierDismissible,
          ),
    );

    return result ?? false;
  }

  /// Factory constructor for creating a logout confirmation dialog
  static Future<bool> logout(
    BuildContext context, {
    required VoidCallback onConfirm,
    String title = 'Logout',
    String message = 'Are you sure you want to logout?',
    String confirmText = 'Logout',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      onConfirm: onConfirm,
      confirmText: confirmText,
      icon: Icons.logout,
      isDestructiveAction: true,
    );
  }

  /// Factory constructor for creating a delete confirmation dialog
  static Future<bool> delete(
    BuildContext context, {
    required VoidCallback onConfirm,
    required String itemType,
    String? title,
    String? message,
  }) {
    return show(
      context: context,
      title: title ?? 'Delete $itemType',
      message:
          message ??
          'Are you sure you want to delete this $itemType? This action cannot be undone.',
      onConfirm: onConfirm,
      confirmText: 'Delete',
      icon: Icons.delete,
      isDestructiveAction: true,
    );
  }
}
