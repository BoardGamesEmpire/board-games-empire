part of 'game_gateway_bloc.dart';

abstract class GameGatewayEvent extends Equatable {
  const GameGatewayEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize the game gateway bloc
class GameGatewayInitialized extends GameGatewayEvent {
  const GameGatewayInitialized();
}

/// Request to load the list of game gateways
class GameGatewayLoadRequested extends GameGatewayEvent {
  const GameGatewayLoadRequested();
}

/// Request to create a new game gateway
class GameGatewayCreateRequested extends GameGatewayEvent {
  final GameGateway gateway;

  const GameGatewayCreateRequested(this.gateway);

  @override
  List<Object?> get props => [gateway];
}

/// Request to update an existing game gateway
class GameGatewayUpdateRequested extends GameGatewayEvent {
  final GameGateway gateway;

  const GameGatewayUpdateRequested(this.gateway);

  @override
  List<Object?> get props => [gateway];
}

/// Request to delete a game gateway
class GameGatewayDeleteRequested extends GameGatewayEvent {
  final String id;

  const GameGatewayDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Change the active tab in the game gateway screen
class GameGatewayTabChanged extends GameGatewayEvent {
  final int tabIndex;

  const GameGatewayTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

/// Change the authentication type for a gateway
class GameGatewayAuthTypeChanged extends GameGatewayEvent {
  final AuthType authType;

  const GameGatewayAuthTypeChanged(this.authType);

  @override
  List<Object?> get props => [authType];
}

/// Toggle a gateway's enabled state
class GameGatewayEnableToggled extends GameGatewayEvent {
  final String id;
  final bool enabled;

  const GameGatewayEnableToggled(this.id, this.enabled);

  @override
  List<Object?> get props => [id, enabled];
}

/// Select a gateway for editing
class GameGatewaySelectedForEdit extends GameGatewayEvent {
  final GameGateway gateway;

  const GameGatewaySelectedForEdit(this.gateway);

  @override
  List<Object?> get props => [gateway];
}

/// Clear the currently selected gateway
class GameGatewayClearSelection extends GameGatewayEvent {
  const GameGatewayClearSelection();
}

/// Update the form validation state
class GameGatewayFormValidated extends GameGatewayEvent {
  final bool isValid;

  const GameGatewayFormValidated(this.isValid);

  @override
  List<Object?> get props => [isValid];
}

/// Update the search query
class GameGatewaySearchQueryChanged extends GameGatewayEvent {
  final String query;

  const GameGatewaySearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Update the auth type filter
class GameGatewayFilterAuthTypeChanged extends GameGatewayEvent {
  final AuthType? authType;

  const GameGatewayFilterAuthTypeChanged(this.authType);

  @override
  List<Object?> get props => [authType];
}

/// Update the enabled-only filter
class GameGatewayFilterEnabledChanged extends GameGatewayEvent {
  final bool enabledOnly;

  const GameGatewayFilterEnabledChanged(this.enabledOnly);

  @override
  List<Object?> get props => [enabledOnly];
}

/// Clear all filters
class GameGatewayClearFilters extends GameGatewayEvent {
  const GameGatewayClearFilters();
}
