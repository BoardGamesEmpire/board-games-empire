import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/platform_service.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/account/session_management_screen.dart';
import '../../screens/config/server_selection_screen.dart';
import '../../services/server_config_service.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();

    if (!context.mounted) return;

    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
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

            if (activeServer != null && !PlatformService.isWeb)
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
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).pushNamed(ServerSelectionScreen.routeName);
                },
              ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.device_hub),
              title: const Text('Manage Sessions'),
              onTap: () {
                Navigator.of(context).pop(); // Close drawer
                Navigator.of(
                  context,
                ).pushNamed(SessionManagementScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security Settings'),
              onTap: () {
                Navigator.of(context).pop(); // Close drawer
                // TODO: Navigate to security settings screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Security settings not implemented yet'),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(SessionManagementScreen.routeName);
              },
              icon: const Icon(Icons.security),
              label: const Text('Manage Sessions'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
