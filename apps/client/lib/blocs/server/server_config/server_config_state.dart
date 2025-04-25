part of 'server_config_bloc.dart';

enum ServerConfigStatus {
  initial,
  loading,
  loaded,
  error,
  validating,
  addingServer,
  updatingServer,
  removingServer,
  changingActiveServer,
  serverAdded,
  serverUpdated,
  serverRemoved,
  activeServerChanged,
}

class ServerConfigState extends Equatable {
  final ServerConfigStatus status;
  final List<ServerConfig> servers;
  final ServerConfig? activeServer;
  final String? error;
  final bool isWebPlatform;
  final bool isInitialized;
  final String? validatingUrl;
  final bool validationSuccessful;
  final ServerConfig? serverBeingModified;

  const ServerConfigState({
    this.status = ServerConfigStatus.initial,
    this.servers = const [],
    this.activeServer,
    this.error,
    this.isWebPlatform = false,
    this.isInitialized = false,
    this.validatingUrl,
    this.validationSuccessful = false,
    this.serverBeingModified,
  });

  ServerConfigState copyWith({
    ServerConfigStatus? status,
    List<ServerConfig>? servers,
    ServerConfig? activeServer,
    String? error,
    bool? isWebPlatform,
    bool? isInitialized,
    String? validatingUrl,
    bool? validationSuccessful,
    ServerConfig? serverBeingModified,
  }) {
    return ServerConfigState(
      status: status ?? this.status,
      servers: servers ?? this.servers,
      activeServer: activeServer ?? this.activeServer,
      error: error,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
      isInitialized: isInitialized ?? this.isInitialized,
      validatingUrl: validatingUrl,
      validationSuccessful: validationSuccessful ?? this.validationSuccessful,
      serverBeingModified: serverBeingModified,
    );
  }

  bool get hasServers => servers.isNotEmpty;
  bool get isLoading => status == ServerConfigStatus.loading;
  bool get isValidating => status == ServerConfigStatus.validating;
  bool get isAddingServer => status == ServerConfigStatus.addingServer;
  bool get isUpdatingServer => status == ServerConfigStatus.updatingServer;
  bool get isRemovingServer => status == ServerConfigStatus.removingServer;
  bool get isChangingActiveServer =>
      status == ServerConfigStatus.changingActiveServer;

  String get activeServerUrl => activeServer?.url ?? '';
  String? get activeServerId => activeServer?.id;

  @override
  List<Object?> get props => [
    status,
    servers,
    activeServer,
    error,
    isWebPlatform,
    isInitialized,
    validatingUrl,
    validationSuccessful,
    serverBeingModified,
  ];
}
