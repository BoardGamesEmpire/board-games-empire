import 'package:flutter/material.dart';

import 'package:board_games_empire/models/game/game_gateway.dart';

class GameGatewayListItem extends StatelessWidget {
  final GameGateway gateway;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onEnabledChanged;

  const GameGatewayListItem({
    super.key,
    required this.gateway,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  gateway.iconUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          gateway.iconUrl!,
                          width: 40,
                          height: 40,
                          errorBuilder:
                              (_, __, ___) => Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.error_rounded,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                        ),
                      )
                      : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.source,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  const SizedBox(width: 12),

                  // Source information
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gateway.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (gateway.description != null)
                          Text(
                            gateway.description!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    gateway.enabled
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                gateway.enabled ? 'Active' : 'Disabled',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      gateway.enabled
                                          ? Colors.green
                                          : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (gateway.authType != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  gateway.authType.toString().split('.').last,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (onEnabledChanged != null)
                        Switch(
                          value: gateway.enabled,
                          onChanged: onEnabledChanged,
                          activeColor: theme.colorScheme.primary,
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit',
                              onPressed: onEdit,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                            ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete',
                              color: Colors.red,
                              onPressed: onDelete,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (gateway.baseUrl != null) ...[
                const Divider(height: 16),
                Row(
                  children: [
                    const Icon(Icons.link, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        gateway.baseUrl!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (gateway.usageCount > 0) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.bar_chart, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Used ${gateway.usageCount} times',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
