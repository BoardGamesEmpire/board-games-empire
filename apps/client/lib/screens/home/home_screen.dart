import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/home/home_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../models/user.dart';
import '../../router/route_constants.dart';
import '../../widgets/ui/theme_toggle.dart';

class HomeScreenBloc extends StatefulWidget {
  static const routeName = AppRoutes.home;

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
    return BlocListener<HomeBloc, HomeState>(
      listenWhen:
          (previous, current) =>
              previous.error != current.error && current.error != null,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen:
              (previous, current) =>
                  previous.isLoggingOut != current.isLoggingOut ||
                  previous.showLogoutConfirmation !=
                      current.showLogoutConfirmation,
          builder: (context, state) {
            if (state.isLoggingOut) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.showLogoutConfirmation) {
              return _buildLogoutConfirmation();
            }

            return _buildMainContent();
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Board Games Empire'),
      actions: [
        // Theme toggle
        const ThemeToggle(),

        // WebSocket status indicator
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen:
              (previous, current) =>
                  previous.connectionStatus != current.connectionStatus,
          builder: (context, state) {
            final isConnected = state.isConnected;
            return Tooltip(
              message:
                  isConnected ? 'Using WebSocket Connection' : 'Using REST API',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: isConnected ? Colors.green : Colors.orange,
                ),
              ),
            );
          },
        ),

        // Reconnect button
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Reconnect WebSocket',
          onPressed: () {
            context.read<HomeBloc>().add(const HomeWebSocketConnectRequested());
          },
        ),

        // Logout button
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<HomeBloc>().add(const HomeLogoutRequested());
          },
          tooltip: 'Logout',
        ),
      ],
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
                leading: const Icon(Icons.device_hub),
                title: const Text('Manage Sessions'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.sessionManagement);
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

              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme Settings'),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.themeSettings);
                },
              ),

              const Divider(),

              _buildConnectionStatus(),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  context.pop();
                  context.read<HomeBloc>().add(const HomeLogoutRequested());
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

  Widget _buildConnectionStatus() {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('Connection Status'),
      subtitle: BlocBuilder<HomeBloc, HomeState>(
        buildWhen:
            (previous, current) =>
                previous.connectionStatus != current.connectionStatus,
        builder: (context, state) {
          final isConnected = state.isConnected;
          return Text(
            isConnected ? 'WebSocket Connected' : 'Using REST API',
            style: TextStyle(color: isConnected ? Colors.green : Colors.orange),
          );
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          context.read<HomeBloc>().add(const HomeWebSocketConnectRequested());
        },
      ),
    );
  }

  Widget _buildLogoutConfirmation() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Logout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Are you sure you want to logout?'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeLogoutCancelled());
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const HomeLogoutConfirmed());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
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
          const SizedBox(height: 16),
          const Text(
            'You are successfully logged in.',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),

          // WebSocket status card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Connection Status',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen:
                        (previous, current) =>
                            previous.connectionStatus !=
                            current.connectionStatus,
                    builder: (context, state) {
                      final isConnected = state.isConnected;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isConnected ? Icons.check_circle : Icons.error,
                            color: isConnected ? Colors.green : Colors.orange,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isConnected
                                ? 'WebSocket Connected'
                                : 'Using REST Fallback',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isConnected ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<HomeBloc>().add(
                        const HomeWebSocketConnectRequested(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reconnect WebSocket'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Connected server info would go here',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
