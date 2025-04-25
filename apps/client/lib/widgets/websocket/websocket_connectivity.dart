import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/websocket/websocket_bloc.dart';

class WebSocketStatusIndicator extends StatelessWidget {
  final bool showLabel;
  final bool allowToggle;

  const WebSocketStatusIndicator({
    super.key,
    this.showLabel = false,
    this.allowToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        Color color;
        IconData icon;
        String statusText;

        switch (state.status) {
          case WebSocketStatus.connected:
            color = Colors.green;
            icon = Icons.wifi;
            statusText = 'Connected';
            break;
          case WebSocketStatus.connecting:
            color = Colors.orange;
            icon = Icons.sync;
            statusText = 'Connecting...';
            break;
          case WebSocketStatus.failed:
            color = Colors.red;
            icon = Icons.error_outline;
            statusText = 'Connection Failed';
            break;
          case WebSocketStatus.disconnected:
          default:
            color = Colors.grey;
            icon = Icons.wifi_off;
            statusText = 'Disconnected';
            break;
        }

        return InkWell(
          onTap: allowToggle ? () => _toggleConnection(context, state) : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 16),
                if (showLabel)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      statusText,
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleConnection(BuildContext context, WebSocketState state) {
    final bloc = context.read<WebSocketBloc>();

    if (state.isConnected || state.isConnecting) {
      bloc.add(const WebSocketDisconnectRequested());
    } else if (state.server != null) {
      bloc.add(WebSocketConnectRequested(state.server!));
    }
  }
}
