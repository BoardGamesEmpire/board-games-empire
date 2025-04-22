part of 'server_config_bloc.dart';

class ServerConfigState extends Equatable {
  final String name;
  final String url;
  final bool isInitialSetup;
  final bool isValidating;
  final bool isValidated;
  final bool isAdding;
  final bool isAdded;
  final ServerConfig? addedServer;
  final String? error;
  final bool isWebPlatform;

  const ServerConfigState({
    this.name = '',
    this.url = '',
    this.isInitialSetup = false,
    this.isValidating = false,
    this.isValidated = false,
    this.isAdding = false,
    this.isAdded = false,
    this.addedServer,
    this.error,
    this.isWebPlatform = false,
  });

  ServerConfigState copyWith({
    String? name,
    String? url,
    bool? isInitialSetup,
    bool? isValidating,
    bool? isValidated,
    bool? isAdding,
    bool? isAdded,
    ServerConfig? addedServer,
    String? error,
    bool? isWebPlatform,
  }) {
    return ServerConfigState(
      name: name ?? this.name,
      url: url ?? this.url,
      isInitialSetup: isInitialSetup ?? this.isInitialSetup,
      isValidating: isValidating ?? this.isValidating,
      isValidated: isValidated ?? this.isValidated,
      isAdding: isAdding ?? this.isAdding,
      isAdded: isAdded ?? this.isAdded,
      addedServer: addedServer ?? this.addedServer,
      error: error,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
    );
  }

  @override
  List<Object?> get props => [
    name,
    url,
    isInitialSetup,
    isValidating,
    isValidated,
    isAdding,
    isAdded,
    addedServer,
    error,
    isWebPlatform,
  ];
}
