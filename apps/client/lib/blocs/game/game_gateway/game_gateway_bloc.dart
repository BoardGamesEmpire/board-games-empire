import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:board_games_empire/models/game/game_gateway.dart';
import 'package:board_games_empire/repositories/game/game_gateway_repository.dart';

part 'game_gateway_event.dart';
part 'game_gateway_state.dart';

class GameGatewayBloc extends Bloc<GameGatewayEvent, GameGatewayState> {
  final GameGatewayRepository _gameRepository;

  GameGatewayBloc({required GameGatewayRepository gameRepository})
    : _gameRepository = gameRepository,
      super(const GameGatewayState()) {
    on<GameGatewayInitialized>(_onInitialized);
    on<GameGatewayLoadRequested>(_onLoadRequested);
    on<GameGatewayCreateRequested>(_onCreateRequested);
    on<GameGatewayUpdateRequested>(_onUpdateRequested);
    on<GameGatewayDeleteRequested>(_onDeleteRequested);
    on<GameGatewayTabChanged>(_onTabChanged);
    on<GameGatewayAuthTypeChanged>(_onAuthTypeChanged);
    on<GameGatewayEnableToggled>(_onEnableToggled);
    on<GameGatewaySelectedForEdit>(_onSelectedForEdit);
    on<GameGatewayClearSelection>(_onClearSelection);
    on<GameGatewayFormValidated>(_onFormValidated);

    on<GameGatewaySearchQueryChanged>(_onSearchQueryChanged);
    on<GameGatewayFilterAuthTypeChanged>(_onFilterAuthTypeChanged);
    on<GameGatewayFilterEnabledChanged>(_onFilterEnabledChanged);
    on<GameGatewayClearFilters>(_onClearFilters);
  }

  Future<void> _onInitialized(
    GameGatewayInitialized event,
    Emitter<GameGatewayState> emit,
  ) async {
    emit(state.copyWith(status: GameGatewayStatus.loading));

    try {
      final gateways = await _gameRepository.getGameGateways();

      emit(
        state.copyWith(
          status: GameGatewayStatus.success,
          gateways: gateways,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameGatewayStatus.error,
          error: 'Failed to load game gateways: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadRequested(
    GameGatewayLoadRequested event,
    Emitter<GameGatewayState> emit,
  ) async {
    emit(state.copyWith(status: GameGatewayStatus.loading));

    try {
      final gateways = await _gameRepository.getGameGateways();

      emit(
        state.copyWith(
          status: GameGatewayStatus.success,
          gateways: gateways,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameGatewayStatus.error,
          error: 'Failed to load game gateways: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCreateRequested(
    GameGatewayCreateRequested event,
    Emitter<GameGatewayState> emit,
  ) async {
    emit(state.copyWith(status: GameGatewayStatus.creating));

    try {
      final newGateway = await _gameRepository.createGameGateway(event.gateway);
      final updatedGateways = [...state.gateways, newGateway];

      emit(
        state.copyWith(
          status: GameGatewayStatus.success,
          gateways: updatedGateways,
          currentTabIndex: 0, // Switch to list tab after creation
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameGatewayStatus.error,
          error: 'Failed to create game gateway: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateRequested(
    GameGatewayUpdateRequested event,
    Emitter<GameGatewayState> emit,
  ) async {
    emit(state.copyWith(status: GameGatewayStatus.updating));

    try {
      final updatedGateway = await _gameRepository.updateGameGateway(
        event.gateway,
      );

      final updatedGateways =
          state.gateways.map((gateway) {
            return gateway.id == updatedGateway.id ? updatedGateway : gateway;
          }).toList();

      emit(
        state.copyWith(
          status: GameGatewayStatus.success,
          gateways: updatedGateways,
          selectedGateway: null,
          currentTabIndex: 0, // Switch to list tab after update
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameGatewayStatus.error,
          error: 'Failed to update game gateway: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    GameGatewayDeleteRequested event,
    Emitter<GameGatewayState> emit,
  ) async {
    emit(state.copyWith(status: GameGatewayStatus.deleting));

    try {
      await _gameRepository.deleteGameGateway(event.id);

      final updatedGateways =
          state.gateways.where((gateway) => gateway.id != event.id).toList();

      emit(
        state.copyWith(
          status: GameGatewayStatus.success,
          gateways: updatedGateways,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameGatewayStatus.error,
          error: 'Failed to delete game gateway: ${e.toString()}',
        ),
      );
    }
  }

  void _onTabChanged(
    GameGatewayTabChanged event,
    Emitter<GameGatewayState> emit,
  ) {
    // If switching away from edit tab, clear selection
    if (state.currentTabIndex == 2 && event.tabIndex != 2) {
      emit(
        state.copyWith(
          currentTabIndex: event.tabIndex,
          selectedGateway: null,
          currentAuthType: null,
        ),
      );
    } else {
      emit(state.copyWith(currentTabIndex: event.tabIndex));
    }
  }

  void _onAuthTypeChanged(
    GameGatewayAuthTypeChanged event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(state.copyWith(currentAuthType: event.authType));
  }

  Future<void> _onEnableToggled(
    GameGatewayEnableToggled event,
    Emitter<GameGatewayState> emit,
  ) async {
    try {
      // Find the gateway to update
      final gateway = state.gateways.firstWhere((g) => g.id == event.id);

      await _gameRepository.patchGameGateway(event.id, {
        'enabled': event.enabled,
      });

      final updatedGateway = gateway.copyWith(
        enabled: event.enabled,
        updatedAt: DateTime.now(),
      );

      final updatedGateways =
          state.gateways.map((gateway) {
            return gateway.id == event.id ? updatedGateway : gateway;
          }).toList();

      emit(state.copyWith(gateways: updatedGateways, error: null));
    } catch (e) {
      emit(
        state.copyWith(
          status: GameGatewayStatus.error,
          error: 'Failed to toggle gateway state: ${e.toString()}',
        ),
      );
    }
  }

  void _onSelectedForEdit(
    GameGatewaySelectedForEdit event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(
      state.copyWith(
        selectedGateway: event.gateway,
        currentAuthType: event.gateway.authType,
        currentTabIndex: 2, // Switch to edit tab
      ),
    );
  }

  void _onClearSelection(
    GameGatewayClearSelection event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(state.copyWith(selectedGateway: null, currentAuthType: null));
  }

  void _onFormValidated(
    GameGatewayFormValidated event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(state.copyWith(isFormValid: event.isValid));
  }

  // New handler methods for search and filtering

  void _onSearchQueryChanged(
    GameGatewaySearchQueryChanged event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilterAuthTypeChanged(
    GameGatewayFilterAuthTypeChanged event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(state.copyWith(filterAuthType: event.authType));
  }

  void _onFilterEnabledChanged(
    GameGatewayFilterEnabledChanged event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(state.copyWith(filterEnabledOnly: event.enabledOnly));
  }

  void _onClearFilters(
    GameGatewayClearFilters event,
    Emitter<GameGatewayState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: '',
        filterAuthType: null,
        filterEnabledOnly: false,
      ),
    );
  }
}
