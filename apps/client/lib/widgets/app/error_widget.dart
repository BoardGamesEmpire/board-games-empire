import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/error/error_bloc.dart';

class ErrorHandler extends StatefulWidget {
  final Widget child;

  const ErrorHandler({super.key, required this.child});

  @override
  State<ErrorHandler> createState() => _ErrorHandlerState();
}

class _ErrorHandlerState extends State<ErrorHandler> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorBloc, ErrorState>(
      listenWhen: (previous, current) => !previous.hasError && current.hasError,
      listener: (context, state) {
        if (state.hasError) {
          if (state.showDialog) {
            _showErrorDialog(context, state);
          } else {
            _showErrorSnackBar(context, state);
          }
        }
      },
      child: widget.child,
    );
  }

  void _showErrorSnackBar(BuildContext context, ErrorState state) {
    final theme = Theme.of(context);

    Color backgroundColor;
    IconData iconData;

    switch (state.errorType) {
      case ErrorType.network:
        backgroundColor = Colors.orange;
        iconData = Icons.wifi_off;
        break;
      case ErrorType.auth:
        backgroundColor = Colors.red;
        iconData = Icons.security;
        break;
      case ErrorType.server:
        backgroundColor = Colors.purple;
        iconData = Icons.dns;
        break;

      case ErrorType.generic:
      default:
        backgroundColor = Colors.red;
        iconData = Icons.error_outline;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                state.message ?? 'An error occurred',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            context.read<ErrorBloc>().add(const ErrorDismissed());
          },
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, ErrorState state) {
    String title;
    IconData iconData;

    switch (state.errorType) {
      case ErrorType.network:
        title = 'Network Error';
        iconData = Icons.wifi_off;
        break;
      case ErrorType.auth:
        title = 'Authentication Error';
        iconData = Icons.security;
        break;
      case ErrorType.server:
        title = 'Server Error';
        iconData = Icons.dns;
        break;
      case ErrorType.generic:
      default:
        title = 'Error';
        iconData = Icons.error_outline;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(iconData, color: Colors.red),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(state.message ?? 'An unexpected error occurred'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ErrorBloc>().add(const ErrorDismissed());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
