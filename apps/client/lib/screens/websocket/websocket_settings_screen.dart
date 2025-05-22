import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/websocket/websocket_bloc.dart';
import '../../repositories/server/server_repository.dart';

class WebSocketSettingsScreen extends StatelessWidget {
  const WebSocketSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket Settings')),
      body: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildConnectionStatus(context, state),
              const Divider(),
              _buildAutoReconnectSwitch(context, state),
              _buildAutoConnectSwitch(context, state),
              const Divider(),
              _buildServerSelector(context, state),
              const SizedBox(height: 24),
              _buildManualConnectionButtons(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context, WebSocketState state) {
    final theme = Theme.of(context);
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (state.status) {
      case WebSocketStatus.connected:
        statusColor = Colors.green;
        statusText = 'Connected';
        statusIcon = Icons.check_circle;
        break;
      case WebSocketStatus.connecting:
        statusColor = Colors.orange;
        statusText = 'Connecting...';
        statusIcon = Icons.pending;
        break;
      case WebSocketStatus.failed:
        statusColor = Colors.red;
        statusText = 'Connection Failed';
        statusIcon = Icons.error;
        break;
      case WebSocketStatus.disconnected:
      default:
        statusColor = Colors.grey;
        statusText = 'Disconnected';
        statusIcon = Icons.offline_bolt;
        break;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection Status', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 16),
                Text(
                  statusText,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (state.server != null) ...[
              const SizedBox(height: 8),
              Text(
                'Server: ${state.server!.name}',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                'URL: ${state.server!.url}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error: ${state.error}',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAutoReconnectSwitch(BuildContext context, WebSocketState state) {
    return SwitchListTile(
      title: const Text('Auto Reconnect'),
      subtitle: const Text(
        'Automatically attempt to reconnect when connection is lost',
      ),
      value: state.autoReconnect,
      onChanged: (value) {
        context.read<WebSocketBloc>().add(WebSocketAutoReconnectChanged(value));
      },
    );
  }

  Widget _buildAutoConnectSwitch(BuildContext context, WebSocketState state) {
    return SwitchListTile(
      title: const Text('Auto Connect'),
      subtitle: const Text('Automatically connect when the server changes'),
      value: state.autoConnect,
      onChanged: (value) {
        // TODO: Implement auto connect functionality
        // context.read<WebSocketBloc>().add(WebSocketAutoConnectChanged(value));
      },
    );
  }

  Widget _buildServerSelector(BuildContext context, WebSocketState state) {
    final serverRepo = context.read<ServerRepository>();
    final servers = serverRepo.servers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text('Server Configuration'),
        ),
        if (servers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No servers configured'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              final isSelected = state.server?.id == server.id;

              return RadioListTile<String>(
                title: Text(server.name),
                subtitle: Text(server.url),
                value: server.id,
                groupValue: state.server?.id,
                onChanged: (_) {
                  context.read<WebSocketBloc>().add(
                    WebSocketServerChanged(server),
                  );
                },
                selected: isSelected,
              );
            },
          ),
      ],
    );
  }

  Widget _buildManualConnectionButtons(
    BuildContext context,
    WebSocketState state,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed:
              state.server != null && state.isDisconnected
                  ? () {
                    context.read<WebSocketBloc>().add(
                      WebSocketConnectRequested(state.server!),
                    );
                  }
                  : null,
          icon: const Icon(Icons.wifi),
          label: const Text('Connect'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed:
              state.isConnected || state.isConnecting
                  ? () {
                    context.read<WebSocketBloc>().add(
                      const WebSocketDisconnectRequested(),
                    );
                  }
                  : null,
          icon: const Icon(Icons.wifi_off),
          label: const Text('Disconnect'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
