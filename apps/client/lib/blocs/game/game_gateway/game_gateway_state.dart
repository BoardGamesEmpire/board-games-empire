part of 'game_gateway_bloc.dart';

enum GameGatewayStatus {
  initial,
  loading,
  success,
  error,
  creating,
  updating,
  deleting,
}

/// State for the game gateway bloc
class GameGatewayState extends Equatable {
  final GameGatewayStatus status;
  final List<GameGateway> gateways;
  final GameGateway? selectedGateway;
  final int currentTabIndex;
  final AuthType? currentAuthType;
  final String? error;
  final bool isFormValid;

  // Search and filter state
  final String searchQuery;
  final AuthType? filterAuthType;
  final bool filterEnabledOnly;

  const GameGatewayState({
    this.status = GameGatewayStatus.initial,
    this.gateways = const [],
    this.selectedGateway,
    this.currentTabIndex = 0,
    this.currentAuthType,
    this.error,
    this.isFormValid = false,
    this.searchQuery = '',
    this.filterAuthType,
    this.filterEnabledOnly = false,
  });

  /// Convenience getter for loading status
  bool get isLoading => status == GameGatewayStatus.loading;

  /// Convenience getter for success status
  bool get isSuccess => status == GameGatewayStatus.success;

  /// Convenience getter for error status
  bool get isError => status == GameGatewayStatus.error;

  /// Convenience getter for creating status
  bool get isCreating => status == GameGatewayStatus.creating;

  /// Convenience getter for updating status
  bool get isUpdating => status == GameGatewayStatus.updating;

  /// Convenience getter for deleting status
  bool get isDeleting => status == GameGatewayStatus.deleting;

  /// Checks if any operation is in progress
  bool get isOperationInProgress =>
      isLoading || isCreating || isUpdating || isDeleting;

  /// Returns filtered gateways based on search and filter criteria
  List<GameGateway> get filteredGateways {
    return gateways.where((gateway) {
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final nameMatch = gateway.name.toLowerCase().contains(query);
        final descMatch =
            gateway.description?.toLowerCase().contains(query) ?? false;
        final urlMatch =
            gateway.baseUrl?.toLowerCase().contains(query) ?? false;

        if (!nameMatch && !descMatch && !urlMatch) {
          return false;
        }
      }

      // Apply auth type filter
      if (filterAuthType != null && gateway.authType != filterAuthType) {
        return false;
      }

      // Apply enabled filter
      if (filterEnabledOnly && !gateway.enabled) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Copy this state with the given values
  GameGatewayState copyWith({
    GameGatewayStatus? status,
    List<GameGateway>? gateways,
    GameGateway? selectedGateway,
    int? currentTabIndex,
    AuthType? currentAuthType,
    String? error,
    bool? isFormValid,
    String? searchQuery,
    AuthType? filterAuthType,
    bool? filterEnabledOnly,
  }) {
    return GameGatewayState(
      status: status ?? this.status,
      gateways: gateways ?? this.gateways,
      selectedGateway: selectedGateway ?? this.selectedGateway,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentAuthType: currentAuthType ?? this.currentAuthType,
      error: error,
      isFormValid: isFormValid ?? this.isFormValid,
      searchQuery: searchQuery ?? this.searchQuery,
      filterAuthType: filterAuthType ?? this.filterAuthType,
      filterEnabledOnly: filterEnabledOnly ?? this.filterEnabledOnly,
    );
  }

  /// Creates a copy with the filter auth type cleared
  GameGatewayState clearFilterAuthType() {
    return GameGatewayState(
      status: status,
      gateways: gateways,
      selectedGateway: selectedGateway,
      currentTabIndex: currentTabIndex,
      currentAuthType: currentAuthType,
      error: error,
      isFormValid: isFormValid,
      searchQuery: searchQuery,
      filterAuthType: null,
      filterEnabledOnly: filterEnabledOnly,
    );
  }

  @override
  List<Object?> get props => [
    status,
    gateways,
    selectedGateway,
    currentTabIndex,
    currentAuthType,
    error,
    isFormValid,
    searchQuery,
    filterAuthType,
    filterEnabledOnly,
  ];
}
