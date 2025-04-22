import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/session/session_bloc.dart';
import '../../models/user.dart';
import '../../services/auth/auth_service.dart';
import '../../di/injection.dart';
import '../../router/app_router.dart';
import '../../router/route_constants.dart';

class SessionManagementScreenBloc extends StatefulWidget {
  const SessionManagementScreenBloc({super.key});

  @override
  State<SessionManagementScreenBloc> createState() =>
      _SessionManagementScreenBlocState();
}

class _SessionManagementScreenBlocState
    extends State<SessionManagementScreenBloc> {
  late StreamSubscription _logoutSubscription;

  @override
  void initState() {
    super.initState();

    final authService = getIt<AuthService>();
    _logoutSubscription = authService.onLogout.listen((event) {
      AppRouter.navigateTo(AppRoutes.login);
    });

    // Load sessions when screen opens
    context.read<SessionBloc>().add(const SessionsRequested());
  }

  void _terminateSession(UserSession session) {
    context.read<SessionBloc>().add(
      SessionTerminated(session.id, isCurrentSession: session.isCurrentSession),
    );
  }

  void _terminateAllSessions() async {
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
                onPressed: () => ctx.pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => ctx.pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Terminate All'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      context.read<SessionBloc>().add(const AllSessionsTerminated());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions'),
        actions: [
          BlocBuilder<SessionBloc, SessionState>(
            buildWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    previous.isEmpty != current.isEmpty,
            builder: (context, state) {
              if (!state.isLoading && !state.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed:
                      () => context.read<SessionBloc>().add(
                        const SessionRefreshed(),
                      ),
                  tooltip: 'Refresh',
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<SessionBloc, SessionState>(
        listenWhen:
            (previous, current) =>
                previous.terminationSuccess != current.terminationSuccess,
        listener: (context, state) {
          if (state.terminationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Session terminated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },

        buildWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.sessions != current.sessions ||
                previous.error != current.error,

        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return _buildErrorView(state.error!);
          } else if (state.isEmpty) {
            return _buildEmptyView();
          } else {
            return _buildSessionsList(
              state.sessions,
              state.terminatingSessionId,
            );
          }
        },
      ),

      bottomNavigationBar: BlocBuilder<SessionBloc, SessionState>(
        buildWhen:
            (previous, current) =>
                previous.isEmpty != current.isEmpty ||
                previous.isLoading != current.isLoading,

        builder: (context, state) {
          if (!state.isEmpty && !state.isLoading) {
            return Padding(
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
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
            onPressed:
                () => context.read<SessionBloc>().add(const SessionRefreshed()),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
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
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed:
                () => context.read<SessionBloc>().add(const SessionRefreshed()),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(
    List<UserSession> sessions,
    String? terminatingSessionId,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isTerminating = session.id == terminatingSessionId;

        return _SessionCard(
          session: session,
          onTerminate: () => _terminateSession(session),
          isTerminating: isTerminating,
        );
      },
    );
  }

  @override
  void dispose() {
    _logoutSubscription.cancel();
    super.dispose();
  }
}

class _SessionCard extends StatelessWidget {
  final UserSession session;
  final VoidCallback onTerminate;
  final bool isTerminating;

  const _SessionCard({
    required this.session,
    required this.onTerminate,
    this.isTerminating = false,
  });

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
                isTerminating
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                    : IconButton(
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
    required this.icon,
    required this.label,
    required this.value,
  });

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
