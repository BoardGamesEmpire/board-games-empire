import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app/app_bloc.dart';
import '../../blocs/websocket/websocket_bloc.dart';

class ConnectionSettingsScreen extends StatelessWidget {
  const ConnectionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Settings')),
      body: Column(
        children: [
          // Internet status card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Internet Connection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AppBloc, AppState>(
                    buildWhen:
                        (previous, current) =>
                            previous.hasInternetConnection !=
                            current.hasInternetConnection,
                    builder: (context, state) {
                      return Row(
                        children: [
                          Icon(
                            state.hasInternetConnection
                                ? Icons.wifi
                                : Icons.wifi_off,
                            color:
                                state.hasInternetConnection
                                    ? Colors.green
                                    : Colors.red,
                            size: 48,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.hasInternetConnection
                                      ? 'Connected to the Internet'
                                      : 'No Internet Connection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        state.hasInternetConnection
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.hasInternetConnection
                                      ? 'You have full access to all app features'
                                      : 'Please check your internet connection to use all features',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // WebSocket settings card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Real-time Connection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<WebSocketBloc, WebSocketState>(
                    buildWhen:
                        (previous, current) =>
                            previous.status != current.status,
                    builder: (context, wsState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildWebSocketStatusIcon(wsState),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getWebSocketStatusText(wsState),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _getWebSocketStatusColor(
                                          wsState,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(_getWebSocketDescription(wsState)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (wsState.error != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade700,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      wsState.error!,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child:
                                    BlocBuilder<WebSocketBloc, WebSocketState>(
                                      buildWhen:
                                          (previous, current) =>
                                              previous.autoReconnect !=
                                              current.autoReconnect,
                                      builder: (context, state) {
                                        return SwitchListTile(
                                          title: const Text('Auto Reconnect'),
                                          value: state.autoReconnect,
                                          onChanged: (value) {
                                            context.read<WebSocketBloc>().add(
                                              WebSocketAutoReconnectChanged(
                                                value,
                                              ),
                                            );
                                          },
                                          dense: true,
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text('Connect'),
                                onPressed:
                                    wsState.status ==
                                                WebSocketStatus.connected ||
                                            wsState.status ==
                                                WebSocketStatus.connecting ||
                                            wsState.server == null
                                        ? null
                                        : () {
                                          context.read<WebSocketBloc>().add(
                                            WebSocketConnectRequested(
                                              wsState.server!,
                                            ),
                                          );
                                        },
                              ),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.close),
                                label: const Text('Disconnect'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed:
                                    wsState.status !=
                                                WebSocketStatus.connected &&
                                            wsState.status !=
                                                WebSocketStatus.connecting
                                        ? null
                                        : () {
                                          context.read<WebSocketBloc>().add(
                                            const WebSocketDisconnectRequested(),
                                          );
                                        },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSocketStatusIcon(WebSocketState state) {
    switch (state.status) {
      case WebSocketStatus.connected:
        return Icon(Icons.cloud_done, color: Colors.green, size: 48);
      case WebSocketStatus.connecting:
        return Icon(Icons.sync, color: Colors.orange, size: 48);
      case WebSocketStatus.failed:
        return Icon(Icons.cloud_off, color: Colors.red, size: 48);
      case WebSocketStatus.disconnected:
      default:
        return Icon(Icons.cloud_off, color: Colors.grey, size: 48);
    }
  }

  String _getWebSocketStatusText(WebSocketState state) {
    switch (state.status) {
      case WebSocketStatus.connected:
        return 'Connected to Real-time Services';
      case WebSocketStatus.connecting:
        return 'Connecting to Real-time Services';
      case WebSocketStatus.failed:
        return 'Real-time Connection Failed';
      case WebSocketStatus.disconnected:
      default:
        return 'Not Connected to Real-time Services';
    }
  }

  Color _getWebSocketStatusColor(WebSocketState state) {
    switch (state.status) {
      case WebSocketStatus.connected:
        return Colors.green;
      case WebSocketStatus.connecting:
        return Colors.orange;
      case WebSocketStatus.failed:
        return Colors.red;
      case WebSocketStatus.disconnected:
      default:
        return Colors.grey;
    }
  }

  String _getWebSocketDescription(WebSocketState state) {
    switch (state.status) {
      case WebSocketStatus.connected:
        return 'You are receiving real-time updates';
      case WebSocketStatus.connecting:
        return 'Establishing connection...';
      case WebSocketStatus.failed:
        return 'Failed to connect. Check your server settings.';
      case WebSocketStatus.disconnected:
      default:
        return 'Connect to receive real-time updates';
    }
  }
}
