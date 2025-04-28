import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app/app_bloc.dart';
import '../../blocs/websocket/websocket_bloc.dart';

/// A reusable widget for displaying connection status information.
class ConnectivityIndicator extends StatelessWidget {
  final bool showLabel;

  final bool compact;

  final bool showDetails;

  final bool allowToggle;

  final VoidCallback? onTap;

  const ConnectivityIndicator({
    super.key,
    this.showLabel = false,
    this.compact = false,
    this.showDetails = false,
    this.allowToggle = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return compact
        ? _buildCompactIndicator(context)
        : _buildFullIndicator(context);
  }

  Widget _buildCompactIndicator(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen:
          (previous, current) =>
              previous.hasInternetConnection != current.hasInternetConnection ||
              previous.isWebSocketConnected != current.isWebSocketConnected,
      builder: (context, state) {
        IconData icon;
        Color color;
        String tooltipText;

        if (!state.hasInternetConnection) {
          icon = Icons.wifi_off;
          color = Colors.red;
          tooltipText = 'No Internet Connection';
        } else if (state.isWebSocketConnected) {
          icon = Icons.cloud_done;
          color = Colors.green;
          tooltipText = 'Real-time Connection Active';
        } else {
          icon = Icons.cloud_off;
          color = Colors.orange;
          tooltipText = 'Using Standard Connection';
        }

        return InkWell(
          onTap: allowToggle ? () => _toggleConnection(context) : onTap,
          borderRadius: BorderRadius.circular(4),
          child: Tooltip(
            message: tooltipText,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 16),
                  if (showLabel) ...[
                    const SizedBox(width: 4),
                    Text(
                      _getShortStatusLabel(state),
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullIndicator(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInternetStatus(context),
            if (showLabel) ...[
              const SizedBox(width: 12),
              const Text('|'),
              const SizedBox(width: 12),
              _buildWebSocketStatus(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInternetStatus(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen:
          (previous, current) =>
              previous.hasInternetConnection != current.hasInternetConnection,
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.hasInternetConnection ? Icons.wifi : Icons.wifi_off,
              color: state.hasInternetConnection ? Colors.green : Colors.red,
              size: 16,
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                state.hasInternetConnection
                    ? 'Internet Connected'
                    : 'No Internet',
                style: TextStyle(
                  color:
                      state.hasInternetConnection ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildWebSocketStatus(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, wsState) {
        Color color;
        IconData icon;
        String text;

        switch (wsState.status) {
          case WebSocketStatus.connected:
            color = Colors.green;
            icon = Icons.sync;
            text = 'Real-time Connected';
            break;
          case WebSocketStatus.connecting:
            color = Colors.orange;
            icon = Icons.sync_problem;
            text = 'Connecting...';
            break;
          case WebSocketStatus.failed:
            color = Colors.red;
            icon = Icons.sync_disabled;
            text = 'Connection Failed';
            break;
          case WebSocketStatus.disconnected:
          default:
            color = Colors.grey;
            icon = Icons.sync_disabled;
            text = 'Real-time Disabled';
            break;
        }

        return InkWell(
          onTap: allowToggle ? () => _toggleConnection(context) : onTap,
          borderRadius: BorderRadius.circular(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              if (showLabel) ...[
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
              if (showDetails && wsState.error != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: wsState.error!,
                  child: const Icon(Icons.info_outline, size: 14),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getShortStatusLabel(AppState state) {
    if (!state.hasInternetConnection) {
      return 'Offline';
    } else if (state.isWebSocketConnected) {
      return 'Real-time';
    } else {
      return 'Standard';
    }
  }

  void _toggleConnection(BuildContext context) {
    final wsState = context.read<WebSocketBloc>().state;

    if (wsState.isConnected || wsState.isConnecting) {
      context.read<WebSocketBloc>().add(const WebSocketDisconnectRequested());
    } else if (wsState.server != null) {
      context.read<WebSocketBloc>().add(
        WebSocketConnectRequested(wsState.server!),
      );
    }
  }
}
