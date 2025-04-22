part of 'server_selection_bloc.dart';

enum ServerSelectionStatus {
  initial,
  loading,
  success,
  empty,
  failure,
  activeServerChanged,
  navigatingToAdd,
}

class ServerSelectionState extends Equatable {
  final ServerSelectionStatus status;
  final List<ServerConfig> servers;
  final ServerConfig? activeServer;
  final ServerConfig? serverToRemove;
  final bool confirmingRemoval;
  final String? error;
  final bool isWebPlatform;

  const ServerSelectionState({
    this.status = ServerSelectionStatus.initial,
    this.servers = const [],
    this.activeServer,
    this.serverToRemove,
    this.confirmingRemoval = false,
    this.error,
    this.isWebPlatform = false,
  });

  bool get isInitial => status == ServerSelectionStatus.initial;
  bool get isLoading => status == ServerSelectionStatus.loading;
  bool get isSuccess => status == ServerSelectionStatus.success;
  bool get isEmpty => status == ServerSelectionStatus.empty;
  bool get isFailure => status == ServerSelectionStatus.failure;
  bool get isActiveServerChanged =>
      status == ServerSelectionStatus.activeServerChanged;
  bool get isNavigatingToAdd => status == ServerSelectionStatus.navigatingToAdd;

  ServerSelectionState copyWith({
    ServerSelectionStatus? status,
    List<ServerConfig>? servers,
    ServerConfig? activeServer,
    ServerConfig? serverToRemove,
    bool? confirmingRemoval,
    String? error,
    bool? isWebPlatform,
  }) {
    return ServerSelectionState(
      status: status ?? this.status,
      servers: servers ?? this.servers,
      activeServer: activeServer ?? this.activeServer,
      serverToRemove: serverToRemove,
      confirmingRemoval: confirmingRemoval ?? this.confirmingRemoval,
      error: error,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
    );
  }

  @override
  List<Object?> get props => [
    status,
    servers,
    activeServer,
    serverToRemove,
    confirmingRemoval,
    error,
    isWebPlatform,
  ];
}
