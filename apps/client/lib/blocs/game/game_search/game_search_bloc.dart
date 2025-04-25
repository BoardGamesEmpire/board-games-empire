import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/game/game.dart';
import '../../../models/search_result.dart';
import '../../../repositories/game/game_repository.dart';

part 'game_search_event.dart';
part 'game_search_state.dart';

class GameSearchBloc extends Bloc<GameSearchEvent, GameSearchState> {
  final GameRepository _gameRepository;
  StreamSubscription? _searchResultsSubscription;
  StreamSubscription? _connectionStatusSubscription;

  GameSearchBloc({required GameRepository gameRepository})
    : _gameRepository = gameRepository,
      super(
        GameSearchState(isWebSocketConnected: gameRepository.isUsingWebSocket),
      ) {
    on<GameSearchQueryChanged>(_onQueryChanged);
    on<GameSearchSourceChanged>(_onSourceChanged);
    on<GameSearchRequested>(_onSearchRequested);
    on<GameSearchResultsReceived>(_onResultsReceived);
    on<GameAddRequested>(_onAddRequested);
    on<GameConnectionStatusChanged>(_onConnectionStatusChanged);

    _searchResultsSubscription = _gameRepository.searchResults.listen(
      (results) => add(GameSearchResultsReceived(results)),
    );

    _connectionStatusSubscription = _gameRepository.connectionStatus.listen(
      (isConnected) => add(GameConnectionStatusChanged(isConnected)),
    );
  }

  void _onQueryChanged(
    GameSearchQueryChanged event,
    Emitter<GameSearchState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  void _onSourceChanged(
    GameSearchSourceChanged event,
    Emitter<GameSearchState> emit,
  ) {
    emit(state.copyWith(externalSource: event.source));
  }

  Future<void> _onSearchRequested(
    GameSearchRequested event,
    Emitter<GameSearchState> emit,
  ) async {
    if (state.query.isEmpty) {
      return;
    }

    emit(state.copyWith(status: GameSearchStatus.loading));

    try {
      final results = await _gameRepository.searchGames(
        state.query,
        state.externalSource,
      );

      emit(
        state.copyWith(
          status: GameSearchStatus.success,
          searchResult: results,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GameSearchStatus.failure, error: e.toString()),
      );
    }
  }

  void _onResultsReceived(
    GameSearchResultsReceived event,
    Emitter<GameSearchState> emit,
  ) {
    if (state.status == GameSearchStatus.loading) {
      emit(
        state.copyWith(
          status: GameSearchStatus.success,
          searchResult: event.results,
          error: null,
        ),
      );
    }
  }

  Future<void> _onAddRequested(
    GameAddRequested event,
    Emitter<GameSearchState> emit,
  ) async {
    emit(state.copyWith(addingGameId: event.game.id));

    try {
      final addedGame = await _gameRepository.addGame(event.game);

      emit(state.copyWith(addedGame: addedGame, addingGameId: null));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to add game: ${e.toString()}',
          addingGameId: null,
        ),
      );
    }
  }

  void _onConnectionStatusChanged(
    GameConnectionStatusChanged event,
    Emitter<GameSearchState> emit,
  ) {
    emit(state.copyWith(isWebSocketConnected: event.isConnected));
  }

  @override
  Future<void> close() {
    _searchResultsSubscription?.cancel();
    _connectionStatusSubscription?.cancel();
    return super.close();
  }
}
