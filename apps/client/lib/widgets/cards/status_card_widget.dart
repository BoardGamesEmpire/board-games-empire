import 'package:flutter/material.dart';

/// A reusable card for displaying status information with consistent styling.
class StatusCard extends StatelessWidget {
  final String title;

  final IconData icon;

  final Color iconColor;

  final String statusText;

  final String? subtitle;

  final List<StatusDetail>? details;

  final String? errorMessage;

  final Widget? actionButton;

  final VoidCallback? onTap;

  final double elevation;

  const StatusCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.statusText,
    this.subtitle,
    this.details,
    this.errorMessage,
    this.actionButton,
    this.onTap,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: elevation,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 12),
                  Text(title, style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(icon, color: iconColor, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: iconColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(subtitle!, style: theme.textTheme.bodyMedium),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              if (details != null && details!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                ...details!.map(
                  (detail) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildDetailRow(detail),
                  ),
                ),
              ],

              if (errorMessage != null) ...[
                const SizedBox(height: 12),
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
                          errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (actionButton != null) ...[
                const SizedBox(height: 16),
                Center(child: actionButton!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(StatusDetail detail) {
    return Row(
      children: [
        if (detail.icon != null) ...[
          Icon(detail.icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
        ],
        Text(
          '${detail.label}:',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(detail.value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  /// Factory constructor for creating a connection status card
  factory StatusCard.connection({
    required bool isConnected,
    String? serverName,
    String? serverUrl,
    String? errorMessage,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
    VoidCallback? onTap,
  }) {
    final statusInfo =
        isConnected
            ? _StatusInfo(
              icon: Icons.cloud_done,
              color: Colors.green,
              text: 'Connected',
              subtitle: 'You are receiving real-time updates',
            )
            : _StatusInfo(
              icon: Icons.cloud_off,
              color: Colors.grey,
              text: 'Disconnected',
              subtitle: 'Connect to receive real-time updates',
            );

    return StatusCard(
      title: 'Connection Status',
      icon: statusInfo.icon,
      iconColor: statusInfo.color,
      statusText: statusInfo.text,
      subtitle: statusInfo.subtitle,
      errorMessage: errorMessage,
      onTap: onTap,
      details: [
        if (serverName != null)
          StatusDetail(label: 'Server', value: serverName),
        if (serverUrl != null) StatusDetail(label: 'URL', value: serverUrl),
      ],
      actionButton:
          isConnected
              ? (onDisconnect != null
                  ? ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_off),
                    label: const Text('Disconnect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade700,
                    ),
                    onPressed: onDisconnect,
                  )
                  : null)
              : (onConnect != null
                  ? ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Connect'),
                    onPressed: onConnect,
                  )
                  : null),
    );
  }

  /// Factory constructor for creating an internet status card
  factory StatusCard.internet({
    required bool hasConnection,
    VoidCallback? onTap,
  }) {
    final statusInfo =
        hasConnection
            ? _StatusInfo(
              icon: Icons.wifi,
              color: Colors.green,
              text: 'Connected to the Internet',
              subtitle: 'You have full access to all app features',
            )
            : _StatusInfo(
              icon: Icons.wifi_off,
              color: Colors.red,
              text: 'No Internet Connection',
              subtitle:
                  'Please check your internet connection to use all features',
            );

    return StatusCard(
      title: 'Internet Connection',
      icon: statusInfo.icon,
      iconColor: statusInfo.color,
      statusText: statusInfo.text,
      subtitle: statusInfo.subtitle,
      onTap: onTap,
    );
  }

  /// Factory constructor for creating a server status card
  factory StatusCard.server({
    required String name,
    required String url,
    required bool isActive,
    DateTime? lastConnected,
    VoidCallback? onEdit,
    VoidCallback? onRemove,
    VoidCallback? onSelect,
  }) {
    String lastConnectedText = 'Never';
    if (lastConnected != null) {
      final now = DateTime.now();
      final difference = now.difference(lastConnected);

      if (difference.inDays == 0) {
        lastConnectedText = 'Today';
      } else if (difference.inDays == 1) {
        lastConnectedText = 'Yesterday';
      } else if (difference.inDays < 7) {
        lastConnectedText = '${difference.inDays} days ago';
      } else {
        lastConnectedText = '${difference.inDays ~/ 7} weeks ago';
      }
    }

    return StatusCard(
      title: 'Server',
      icon: Icons.dns,
      iconColor: isActive ? Colors.green : Colors.grey,
      statusText: name,
      subtitle: url,
      details: [
        StatusDetail(label: 'Last connected', value: lastConnectedText),
        StatusDetail(label: 'Status', value: isActive ? 'Active' : 'Inactive'),
      ],
      actionButton:
          onSelect != null
              ? ElevatedButton(
                onPressed: onSelect,
                child: const Text('Select Server'),
              )
              : null,
    );
  }
}

/// Helper class for storing status information
class _StatusInfo {
  final IconData icon;
  final Color color;
  final String text;
  final String subtitle;

  _StatusInfo({
    required this.icon,
    required this.color,
    required this.text,
    required this.subtitle,
  });
}

/// Class to represent a detail row in the status card
class StatusDetail {
  final String label;
  final String value;
  final IconData? icon;

  StatusDetail({required this.label, required this.value, this.icon});
}
