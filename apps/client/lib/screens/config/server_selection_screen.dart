import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/server/server_config/server_config_bloc.dart';
import '../../models/config/server_config.dart';
import '../../router/app_router.dart';
import '../../router/route_constants.dart';

class ServerSelectionScreenBloc extends StatefulWidget {
  static const routeName = AppRoutes.serverSelection;

  const ServerSelectionScreenBloc({super.key});

  @override
  State<ServerSelectionScreenBloc> createState() =>
      _ServerSelectionScreenBlocState();
}

class _ServerSelectionScreenBlocState extends State<ServerSelectionScreenBloc> {
  @override
  void initState() {
    super.initState();
    context.read<ServerConfigBloc>().add(const ServerConfigInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServerConfigBloc, ServerConfigState>(
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            previous.error != current.error;
      },
      listener: (context, state) {
        if (state.error != null) {
          _showErrorSnackBar(state.error!);
        } else if (state.status == ServerConfigStatus.activeServerChanged) {
          AppRouter.navigateTo(AppRoutes.login);
        } else if (state.status == ServerConfigStatus.serverAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ServerConfigStatus.serverRemoved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server removed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ServerConfigStatus.serverUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Server'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state.isLoading ? null : _refreshServers,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ServerConfigState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!state.hasServers) {
      return _buildEmptyState();
    }

    return _buildServerList(state.servers, state.activeServerId);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.dns_outlined, size: 64, color: Colors.grey),
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
            onPressed: _navigateToAddServer,
            icon: const Icon(Icons.add),
            label: const Text('Add Server'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerList(List<ServerConfig> servers, String? activeServerId) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: servers.length + 1, // +1 for the add button
      itemBuilder: (ctx, index) {
        if (index == servers.length) {
          // Add server button at the bottom
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: OutlinedButton.icon(
              onPressed: _navigateToAddServer,
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
          isActive: server.id == activeServerId,
          onSelect: () => _selectServer(server.id),
          onEdit: () => _editServer(server),
          onRemove: () => _requestRemoveServer(server),
          lastConnected: _formatDate(server.lastConnectedAt),
        );
      },
    );
  }

  Widget _buildRemovalConfirmation(ServerConfig server) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Remove Server',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to remove "${server.name}"?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshServers() {
    context.read<ServerConfigBloc>().add(const ServerConfigLoadRequested());
  }

  void _selectServer(String serverId) {
    context.read<ServerConfigBloc>().add(ServerConfigActiveChanged(serverId));
  }

  Future<void> _navigateToAddServer() async {
    AppRouter.navigateTo(AppRoutes.serverConfig);
  }

  Future<void> _editServer(ServerConfig server) async {
    // Pass server info to edit screen
    AppRouter.navigateTo(
      '${AppRoutes.serverConfig}/edit',
      arguments: {
        'serverId': server.id,
        'name': server.name,
        'url': server.url,
      },
    );
  }

  Future<void> _requestRemoveServer(ServerConfig server) async {
    // Show dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildRemovalConfirmation(server),
    );

    if (confirmed == true && mounted) {
      context.read<ServerConfigBloc>().add(ServerConfigRemoved(server.id));
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
}

class _ServerCard extends StatelessWidget {
  final ServerConfig server;
  final bool isActive;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final String lastConnected;

  const _ServerCard({
    required this.server,
    required this.isActive,
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
                  if (isActive)
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
