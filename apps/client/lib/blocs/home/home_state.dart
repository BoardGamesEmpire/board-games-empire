part of 'home_bloc.dart';

enum ConnectionStatus { disconnected, connecting, connected }

class HomeState extends Equatable {
  final ConnectionStatus connectionStatus;
  final bool showLogoutConfirmation;
  final bool isLoggingOut;
  final String? error;

  const HomeState({
    this.connectionStatus = ConnectionStatus.disconnected,
    this.showLogoutConfirmation = false,
    this.isLoggingOut = false,
    this.error,
  });

  bool get isConnected => connectionStatus == ConnectionStatus.connected;
  bool get isConnecting => connectionStatus == ConnectionStatus.connecting;
  bool get isDisconnected => connectionStatus == ConnectionStatus.disconnected;

  HomeState copyWith({
    ConnectionStatus? connectionStatus,
    bool? showLogoutConfirmation,
    bool? isLoggingOut,
    String? error,
  }) {
    return HomeState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      showLogoutConfirmation:
          showLogoutConfirmation ?? this.showLogoutConfirmation,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    connectionStatus,
    showLogoutConfirmation,
    isLoggingOut,
    error,
  ];
}
