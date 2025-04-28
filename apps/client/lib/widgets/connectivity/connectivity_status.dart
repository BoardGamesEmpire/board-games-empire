import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app/app_bloc.dart';
import '../../blocs/websocket/websocket_bloc.dart';

class ConnectivityStatusWidget extends StatelessWidget {
  final bool showDetails;
  final bool compact;

  const ConnectivityStatusWidget({
    super.key,
    this.showDetails = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen:
          (previous, current) =>
              previous.hasInternetConnection != current.hasInternetConnection ||
              previous.isWebSocketConnected != current.isWebSocketConnected,
      builder: (context, state) {
        if (compact) {
          return _buildCompactIndicator(context, state);
        }

        return _buildFullIndicator(context, state);
      },
    );
  }

  Widget _buildCompactIndicator(BuildContext context, AppState state) {
    IconData icon;
    Color color;

    if (!state.hasInternetConnection) {
      icon = Icons.wifi_off;
      color = Colors.red;
    } else if (state.isWebSocketConnected) {
      icon = Icons.cloud_done;
      color = Colors.green;
    } else {
      icon = Icons.cloud_off;
      color = Colors.orange;
    }

    return Tooltip(
      message: _getStatusText(state),
      child: Icon(icon, color: color, size: 16),
    );
  }

  Widget _buildFullIndicator(BuildContext context, AppState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInternetStatus(context, state),
            if (state.hasInternetConnection) ...[
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

  Widget _buildInternetStatus(BuildContext context, AppState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          state.hasInternetConnection ? Icons.wifi : Icons.wifi_off,
          color: state.hasInternetConnection ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          state.hasInternetConnection ? 'Internet Connected' : 'No Internet',
          style: TextStyle(
            color: state.hasInternetConnection ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            if (showDetails && wsState.error != null) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: wsState.error!,
                child: const Icon(Icons.info_outline, size: 14),
              ),
            ],
          ],
        );
      },
    );
  }

  String _getStatusText(AppState state) {
    if (!state.hasInternetConnection) {
      return 'No Internet Connection';
    } else if (state.isWebSocketConnected) {
      return 'Real-time Connection Active';
    } else {
      return 'Using Standard Connection';
    }
  }
}
