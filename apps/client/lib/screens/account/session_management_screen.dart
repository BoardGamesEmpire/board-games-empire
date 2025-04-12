import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class SessionManagementScreen extends StatefulWidget {
  static const routeName = '/account/sessions';

  const SessionManagementScreen({super.key});

  @override
  State<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  List<UserSession> _sessions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final sessions = await authService.getActiveSessions();

      if (mounted) {
        setState(() {
          _sessions = sessions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load sessions: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _terminateSession(UserSession session) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.logoutSession(session.id);

      if (success) {
        if (session.isCurrentSession) {
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }

        if (mounted) {
          await _loadSessions();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session terminated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to terminate session'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _terminateAllSessions() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Terminate All Sessions'),
            content: const Text(
              'Are you sure you want to terminate all sessions? '
              'You will be logged out from all devices, including this one.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Terminate All'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logout(allSessions: true);

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions'),
        actions: [
          if (_sessions.isNotEmpty && !_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadSessions,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _buildErrorView()
              : _sessions.isEmpty
              ? _buildEmptyView()
              : _buildSessionsList(),
      bottomNavigationBar:
          _sessions.isNotEmpty && !_isLoading
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _terminateAllSessions,
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out From All Devices'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.devices, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No active sessions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'You are currently only logged in on this device.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadSessions,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              _error ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadSessions,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        return _SessionCard(
          session: session,
          onTerminate: () => _terminateSession(session),
        );
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final UserSession session;
  final VoidCallback onTerminate;

  const _SessionCard({required this.session, required this.onTerminate});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(date)}, ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.yMMMd().add_jm().format(date);
    }
  }

  String _formatLocation() {
    if (session.ipAddress == null) return 'Unknown location';
    // In a real app, you might want to use a geolocation service
    // to convert IP address to a human-readable location
    return 'IP: ${session.ipAddress}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getDeviceIcon(),
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.deviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (session.isCurrentSession)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Current Device',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: onTerminate,
                  tooltip: 'Terminate Session',
                  color: Colors.red,
                ),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Last active',
              value: _formatDate(session.lastActive),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Started',
              value: _formatDate(session.createdAt),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: _formatLocation(),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.timer_outlined,
              label: 'Expires',
              value: _formatDate(session.expiresAt),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDeviceIcon() {
    final deviceInfo = session.deviceInfo;
    if (deviceInfo == null) return Icons.devices;

    final userAgent = deviceInfo['userAgent'] as String? ?? '';
    final os = deviceInfo['os'] as String? ?? '';

    if (userAgent.contains('Mobile') ||
        os.contains('Android') ||
        os.contains('iOS')) {
      return Icons.smartphone;
    } else if (userAgent.contains('Tablet') || os.contains('iPad')) {
      return Icons.tablet;
    } else if (os.contains('Mac')) {
      return Icons.laptop_mac;
    } else if (os.contains('Windows')) {
      return Icons.laptop_windows;
    } else if (os.contains('Linux')) {
      return Icons.computer;
    }

    return Icons.devices;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
