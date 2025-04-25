import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/app/app_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/websocket/websocket_bloc.dart';
import '../../router/route_constants.dart';
import '../../widgets/connectivity/connectivity_status_widget.dart';
import '../../widgets/connectivity/connectivity_status_bar_widget.dart';
import '../../widgets/ui/theme_toggle.dart';

class HomeScreenBloc extends StatefulWidget {
  const HomeScreenBloc({super.key});

  @override
  State<HomeScreenBloc> createState() => _HomeScreenBlocState();
}

class _HomeScreenBlocState extends State<HomeScreenBloc> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConnectivityStatusBar(
        title: const Text('Board Games Empire'),
        actions: [
          const ThemeToggle(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildMainContent(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState.user;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildUserHeader(user),

              _buildServerInfo(),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Account'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.account);
                },
              ),

              ListTile(
                leading: const Icon(Icons.device_hub),
                title: const Text('Sessions'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.sessionManagement);
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings_applications),
                title: const Text('Connection Settings'),
                subtitle: const ConnectivityStatusWidget(
                  compact: true,
                  showDetails: true,
                ),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.connectionSettings);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.games),
                title: const Text('Game Collection'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.gameCollection);
                },
              ),

              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search Games'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.gameSearch);
                },
              ),

              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Chat'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.chat);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme Settings'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.themeSettings);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  context.pop();
                  _showLogoutConfirmation();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserHeader(User? user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user?.username ?? 'User'),
      accountEmail: Text(user?.email ?? ''),
      currentAccountPicture: CircleAvatar(
        backgroundImage:
            user?.avatar != null ? NetworkImage(user!.avatar!) : null,
        child:
            user?.avatar == null
                ? Text(
                  user?.username.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(fontSize: 24),
                )
                : null,
      ),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildServerInfo() {
    // Server info would use a ServerBloc in a full implementation
    return ListTile(
      leading: const Icon(Icons.dns),
      title: const Text('Server'),
      subtitle: const Text(
        'Current Server',
        style: TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.swap_horiz),
      onTap: () {
        context.pop();
        context.push(AppRoutes.serverSelection);
      },
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: ConnectivityStatusWidget(showDetails: true),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<AppBloc, AppState>(
                  buildWhen:
                      (previous, current) =>
                          previous.isWebSocketConnected !=
                          current.isWebSocketConnected,
                  builder: (context, state) {
                    final IconData iconData =
                        state.isWebSocketConnected
                            ? Icons.check_circle_outline
                            : Icons.info_outline;
                    final Color iconColor =
                        state.isWebSocketConnected
                            ? Colors.green
                            : Colors.orange;

                    return Icon(iconData, size: 80, color: iconColor);
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final user = state.user;
                    return Text(
                      'Welcome, ${user?.firstName ?? user?.username ?? 'User'}!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: BlocBuilder<AppBloc, AppState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isWebSocketConnected !=
                            current.isWebSocketConnected,
                    builder: (context, state) {
                      final message =
                          state.isWebSocketConnected
                              ? 'You are connected to real-time services and will receive instant updates.'
                              : 'You are using standard connection. Some features may be limited.';

                      return Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              state.isWebSocketConnected
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 48),

                // WebSocket connection button
                BlocBuilder<WebSocketBloc, WebSocketState>(
                  buildWhen:
                      (previous, current) => previous.status != current.status,
                  builder: (context, wsState) {
                    if (wsState.status == WebSocketStatus.connected) {
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Disconnect WebSocket'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade700,
                        ),
                        onPressed: () {
                          context.read<WebSocketBloc>().add(
                            const WebSocketDisconnectRequested(),
                          );
                        },
                      );
                    } else if (wsState.status == WebSocketStatus.connecting) {
                      return ElevatedButton.icon(
                        icon: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        label: const Text('Connecting...'),
                        onPressed: null,
                      );
                    } else {
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Connect to Real-time Services'),
                        onPressed:
                            wsState.server != null
                                ? () {
                                  context.read<WebSocketBloc>().add(
                                    WebSocketConnectRequested(wsState.server!),
                                  );
                                }
                                : null,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
