import 'package:board_games_empire/router/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/server_config_service.dart';
import '../../services/auth/auth_service.dart';
import '../../models/config/server_config.dart';
import 'server_config_screen.dart';

class ServerSelectionScreen extends StatefulWidget {
  static const routeName = '/server-selection';

  const ServerSelectionScreen({super.key});

  @override
  State<ServerSelectionScreen> createState() => _ServerSelectionScreenState();
}

class _ServerSelectionScreenState extends State<ServerSelectionScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshServers();
    });
  }

  Future<void> _refreshServers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final configService = Provider.of<ServerConfigService>(
        context,
        listen: false,
      );
      await configService.initialize();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectServer(String serverId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final configService = Provider.of<ServerConfigService>(
        context,
        listen: false,
      );
      final authService = Provider.of<AuthService>(context, listen: false);

      await configService.setActiveServer(serverId);

      // Reset auth service with new server URL
      final server = configService.activeServer;
      if (server != null) {
        authService.setBaseUrl(server.url);
      }

      if (!mounted) return;
      context.go(AppRoutes.login);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting server: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addNewServer() async {
    final result = await context.push<ServerConfig>('/server-config');

    if (result != null) {
      await _selectServer(result.id);
    }
  }

  Future<void> _editServer(ServerConfig server) async {
    // TODO: Implement edit server dialog
    // For now, we just pop up a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit server feature coming soon')),
    );
  }

  Future<void> _removeServer(ServerConfig server) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Remove Server'),
            content: Text('Are you sure you want to remove "${server.name}"?'),
            actions: [
              TextButton(
                onPressed: () => ctx.pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => ctx.pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Remove'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final configService = Provider.of<ServerConfigService>(
          context,
          listen: false,
        );
        await configService.removeServer(server.id);

        if (!mounted) return;

        if (!configService.hasServers) {
          context.go('/server-config?initial=true');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing server: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(date)}, ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Server'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshServers,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<ServerConfigService>(
                builder: (ctx, configService, _) {
                  final servers = configService.serverConfigs;

                  if (servers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.dns_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Servers Configured',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Add a server to get started.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: _addNewServer,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Server'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: servers.length + 1, // +1 for the add button
                    itemBuilder: (ctx, index) {
                      if (index == servers.length) {
                        // Add server button at the bottom
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: OutlinedButton.icon(
                            onPressed: _addNewServer,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Another Server'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        );
                      }

                      final server = servers[index];
                      return _ServerCard(
                        server: server,
                        onSelect: () => _selectServer(server.id),
                        onEdit: () => _editServer(server),
                        onRemove: () => _removeServer(server),
                        lastConnected: _formatDate(server.lastConnectedAt),
                      );
                    },
                  );
                },
              ),
    );
  }
}

class _ServerCard extends StatelessWidget {
  final ServerConfig server;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final String lastConnected;

  const _ServerCard({
    required this.server,
    required this.onSelect,
    required this.onEdit,
    required this.onRemove,
    required this.lastConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.dns, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          server.url,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (server.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last connected: $lastConnected',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: onEdit,
                        tooltip: 'Edit',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        splashRadius: 24,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: onRemove,
                        tooltip: 'Remove',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        splashRadius: 24,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
