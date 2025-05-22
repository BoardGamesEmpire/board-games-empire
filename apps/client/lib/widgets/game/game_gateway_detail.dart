import 'package:flutter/material.dart';

import 'package:board_games_empire/models/game/game_gateway.dart';

class GameGatewayDetail extends StatelessWidget {
  final GameGateway gateway;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onEnabledChanged;

  const GameGatewayDetail({
    super.key,
    required this.gateway,
    this.onEdit,
    this.onDelete,
    this.onEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with actions
            Row(
              children: [
                if (gateway.iconUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        gateway.iconUrl!,
                        width: 48,
                        height: 48,
                        errorBuilder:
                            (_, __, ___) => const Icon(Icons.source, size: 48),
                      ),
                    ),
                  ),

                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gateway.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (gateway.description != null)
                        Text(
                          gateway.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onEnabledChanged != null)
                      Switch(
                        value: gateway.enabled,
                        onChanged: onEnabledChanged,
                      ),
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Source',
                        onPressed: onEdit,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete Source',
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            // Base details
            _buildDetailSection(context, 'API Information', [
              if (gateway.baseUrl != null)
                _buildDetailRow(context, 'Base URL', gateway.baseUrl!),
              if (gateway.apiVersion != null)
                _buildDetailRow(context, 'API Version', gateway.apiVersion!),
              if (gateway.apiDocumentation != null)
                _buildDetailRow(
                  context,
                  'Documentation',
                  gateway.apiDocumentation!,
                  isUrl: true,
                ),
              if (gateway.websiteUrl != null)
                _buildDetailRow(
                  context,
                  'Website',
                  gateway.websiteUrl!,
                  isUrl: true,
                ),
            ]),

            const SizedBox(height: 16),

            // Authentication details
            _buildDetailSection(context, 'Authentication', [
              _buildDetailRow(
                context,
                'Type',
                gateway.authType != null
                    ? gateway.authType.toString().split('.').last
                    : 'None',
              ),
              // We don't show sensitive auth params for security
              if (gateway.authType != null && gateway.authType != AuthType.None)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Authentication parameters are configured.'),
                ),
            ]),

            const SizedBox(height: 16),

            // Usage statistics
            _buildDetailSection(context, 'Usage Statistics', [
              _buildDetailRow(
                context,
                'Times Used',
                gateway.usageCount.toString(),
              ),
              if (gateway.lastUsed != null)
                _buildDetailRow(
                  context,
                  'Last Used',
                  _formatDateTime(gateway.lastUsed!),
                ),
              _buildDetailRow(
                context,
                'Created',
                _formatDateTime(gateway.createdAt),
              ),
              _buildDetailRow(
                context,
                'Last Updated',
                _formatDateTime(gateway.updatedAt),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> details,
  ) {
    if (details.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isUrl = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child:
                isUrl
                    ? InkWell(
                      onTap: () {
                        // TODO: Implement URL opening
                      },
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                    : Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
