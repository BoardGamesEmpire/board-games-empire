part of 'server_bloc.dart';

enum ServerStatus {
  initial,
  loading,
  loaded,
  noServers,
  error,
  testing,
  testSuccess,
  testFailure,
}

class ServerState extends Equatable {
  const ServerState({
    this.status = ServerStatus.initial,
    this.servers = const [],
    this.activeServer,
    this.error,
    this.lastTestedUrl,
    this.isWebPlatform = false,
    this.lastAddedServer,
  });

  const ServerState.initial() : this();

  const ServerState.noServers() : this(status: ServerStatus.noServers);

  const ServerState.loaded({
    required List<ServerConfig> servers,
    required ServerConfig? activeServer,
    required bool isWebPlatform,
    ServerConfig? lastAddedServer,
  }) : this(
         status: ServerStatus.loaded,
         servers: servers,
         activeServer: activeServer,
         isWebPlatform: isWebPlatform,
         lastAddedServer: lastAddedServer,
       );

  const ServerState.error(String message)
    : this(status: ServerStatus.error, error: message);

  final ServerStatus status;
  final List<ServerConfig> servers;
  final ServerConfig? activeServer;
  final String? error;
  final String? lastTestedUrl;
  final bool isWebPlatform;
  final ServerConfig? lastAddedServer;

  bool get hasServers => servers.isNotEmpty;
  bool get isInitialized => status != ServerStatus.initial;

  ServerState copyWith({
    ServerStatus? status,
    List<ServerConfig>? servers,
    ServerConfig? activeServer,
    String? error,
    String? lastTestedUrl,
    bool? isWebPlatform,
    ServerConfig? lastAddedServer,
  }) {
    return ServerState(
      status: status ?? this.status,
      servers: servers ?? this.servers,
      activeServer: activeServer ?? this.activeServer,
      error: error ?? this.error,
      lastTestedUrl: lastTestedUrl ?? this.lastTestedUrl,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
      lastAddedServer: lastAddedServer ?? this.lastAddedServer,
    );
  }

  @override
  List<Object?> get props => [
    status,
    servers,
    activeServer,
    error,
    lastTestedUrl,
    isWebPlatform,
    lastAddedServer,
  ];
}
