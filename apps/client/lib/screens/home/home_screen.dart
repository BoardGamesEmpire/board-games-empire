import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../di/injection.dart';
import '../../services/websocket/websocket_manager.dart';
import '../../services/server_config_service.dart';
import '../../services/auth/auth_service.dart';
import '../../services/game/game_service.dart';
import '../account/session_management_screen.dart';
import '../config/server_selection_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WebSocketManager _websocketManager = getIt<WebSocketManager>();
  final ServerConfigService _serverConfigService = getIt<ServerConfigService>();
  final GameService _gameService = getIt<GameService>();
  final AuthService _authService = getIt<AuthService>();

  late StreamSubscription _logoutSubscription;

  @override
  void initState() {
    super.initState();

    _initializeWebSocket();

    _logoutSubscription = _authService.onLogout.listen((event) {
      if (mounted) {
        context.go(LoginScreen.routeName);
      }
    });
  }

  Future<void> _initializeWebSocket() async {
    if (_serverConfigService.activeServer != null) {
      final server = _serverConfigService.activeServer!;

      await _websocketManager.connect(server.url, server.id);
    }
  }

  void _logout(BuildContext context) async {
    try {
      await _authService.logout();

      // Go Router automatically handles the redirect to login via the refreshListenable
    } catch (e) {
      if (mounted) {
        // TODO: context across multiple async calls
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: ${e.toString()}')),
        );
      }
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => ctx.pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ctx.pop();
                  _logout(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final serverConfigService = Provider.of<ServerConfigService>(context);
    final user = authService.currentUser;
    final activeServer = serverConfigService.activeServer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Board Games Empire'),
        actions: [
          StreamBuilder<bool>(
            stream: _websocketManager.statusStream,
            initialData: _websocketManager.isConnected,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Tooltip(
                message:
                    isConnected
                        ? 'Using WebSocket Connection'
                        : 'Using REST API',
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
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reconnect WebSocket',
            onPressed: _initializeWebSocket,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
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
            ),

            if (activeServer != null)
              ListTile(
                leading: const Icon(Icons.dns),
                title: Text(activeServer.name),
                subtitle: Text(
                  activeServer.url,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.swap_horiz),
                onTap: () {
                  context.pop();
                  context.push(ServerSelectionScreen.routeName);
                },
              ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.device_hub),
              title: const Text('Manage Sessions'),
              onTap: () {
                context.pop();
                context.push('/sessions');
              },
            ),

            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Games'),
              onTap: () {
                context.pop();
                context.push('/games/search');
              },
            ),

            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                context.pop();
                context.push('/chat');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Connection Status'),
              subtitle: StreamBuilder<bool>(
                stream: _websocketManager.statusStream,
                initialData: _websocketManager.isConnected,
                builder: (context, snapshot) {
                  final isConnected = snapshot.data ?? false;
                  return Text(
                    isConnected ? 'WebSocket Connected' : 'Using REST API',
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.orange,
                    ),
                  );
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initializeWebSocket,
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                context.pop();
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome, ${user?.firstName ?? user?.username ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
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
                    StreamBuilder<bool>(
                      stream: _websocketManager.statusStream,
                      initialData: _websocketManager.isConnected,
                      builder: (context, snapshot) {
                        final isConnected = snapshot.data ?? false;
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
                                color:
                                    isConnected ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _initializeWebSocket,
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
                    Text(
                      'Server: ${activeServer?.name ?? 'None'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      activeServer?.url ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoutSubscription.cancel();
    super.dispose();
  }
}
