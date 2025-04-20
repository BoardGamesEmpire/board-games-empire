import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/game/game_collection.dart';
import '../../../repositories/game/game_repository.dart';

part 'game_collection_event.dart';
part 'game_collection_state.dart';

class GameCollectionBloc
    extends Bloc<GameCollectionEvent, GameCollectionState> {
  final GameRepository _gameRepository;

  GameCollectionBloc({required GameRepository gameRepository})
    : _gameRepository = gameRepository,
      super(const GameCollectionState()) {
    on<GameCollectionRequested>(_onGameCollectionRequested);
    on<GameCollectionGameAdded>(_onGameCollectionGameAdded);
    on<GameCollectionGameRemoved>(_onGameCollectionGameRemoved);
    on<GameCollectionGameUpdated>(_onGameCollectionGameUpdated);
    on<GameCollectionFiltered>(_onGameCollectionFiltered);
    on<GameCollectionSorted>(_onGameCollectionSorted);
  }

  Future<void> _onGameCollectionRequested(
    GameCollectionRequested event,
    Emitter<GameCollectionState> emit,
  ) async {
    emit(state.copyWith(status: GameCollectionStatus.loading));

    try {
      final games = await _gameRepository.getCollection();
      final filteredGames = _applyFiltersAndSort(
        games,
        state.searchQuery,
        state.onlyFavorites,
        state.sortOption,
      );

      emit(
        state.copyWith(
          status: GameCollectionStatus.success,
          games: games,
          filteredGames: filteredGames,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameCollectionStatus.failure,
          errorMessage: 'Failed to load game collection: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGameCollectionGameAdded(
    GameCollectionGameAdded event,
    Emitter<GameCollectionState> emit,
  ) async {
    emit(state.copyWith(status: GameCollectionStatus.loading));

    try {
      await _gameRepository.addGameToCollection(event.gameId, event.quantity);

      // Refresh collection
      final games = await _gameRepository.getCollection();
      final filteredGames = _applyFiltersAndSort(
        games,
        state.searchQuery,
        state.onlyFavorites,
        state.sortOption,
      );

      emit(
        state.copyWith(
          status: GameCollectionStatus.success,
          games: games,
          filteredGames: filteredGames,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameCollectionStatus.failure,
          errorMessage: 'Failed to add game to collection: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGameCollectionGameRemoved(
    GameCollectionGameRemoved event,
    Emitter<GameCollectionState> emit,
  ) async {
    emit(state.copyWith(status: GameCollectionStatus.loading));

    try {
      await _gameRepository.removeGameFromCollection(event.gameId);

      // Refresh collection
      final games = await _gameRepository.getCollection();
      final filteredGames = _applyFiltersAndSort(
        games,
        state.searchQuery,
        state.onlyFavorites,
        state.sortOption,
      );

      emit(
        state.copyWith(
          status: GameCollectionStatus.success,
          games: games,
          filteredGames: filteredGames,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameCollectionStatus.failure,
          errorMessage:
              'Failed to remove game from collection: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGameCollectionGameUpdated(
    GameCollectionGameUpdated event,
    Emitter<GameCollectionState> emit,
  ) async {
    emit(state.copyWith(status: GameCollectionStatus.loading));

    try {
      await _gameRepository.updateGameInCollection(
        event.gameId,
        quantity: event.quantity,
        rating: event.rating,
        comment: event.comment,
        favorite: event.favorite,
      );

      // Refresh collection
      final games = await _gameRepository.getCollection();
      final filteredGames = _applyFiltersAndSort(
        games,
        state.searchQuery,
        state.onlyFavorites,
        state.sortOption,
      );

      emit(
        state.copyWith(
          status: GameCollectionStatus.success,
          games: games,
          filteredGames: filteredGames,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GameCollectionStatus.failure,
          errorMessage: 'Failed to update game in collection: ${e.toString()}',
        ),
      );
    }
  }

  void _onGameCollectionFiltered(
    GameCollectionFiltered event,
    Emitter<GameCollectionState> emit,
  ) {
    final filteredGames = _applyFiltersAndSort(
      state.games,
      event.query,
      event.onlyFavorites,
      state.sortOption,
    );

    emit(
      state.copyWith(
        filteredGames: filteredGames,
        searchQuery: event.query,
        onlyFavorites: event.onlyFavorites,
      ),
    );
  }

  void _onGameCollectionSorted(
    GameCollectionSorted event,
    Emitter<GameCollectionState> emit,
  ) {
    final filteredGames = _applyFiltersAndSort(
      state.games,
      state.searchQuery,
      state.onlyFavorites,
      event.sortOption,
    );

    emit(
      state.copyWith(
        filteredGames: filteredGames,
        sortOption: event.sortOption,
      ),
    );
  }

  List<GameCollection> _applyFiltersAndSort(
    List<GameCollection> games,
    String? query,
    bool? onlyFavorites,
    GameCollectionSortOption sortOption,
  ) {
    // Apply filters
    var filtered = List<GameCollection>.from(games);

    if (query != null && query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      filtered =
          filtered
              .where(
                (item) =>
                    item.game.title.toLowerCase().contains(lowercaseQuery) ||
                    (item.game.subtitle?.toLowerCase().contains(
                          lowercaseQuery,
                        ) ??
                        false),
              )
              .toList();
    }

    if (onlyFavorites == true) {
      filtered = filtered.where((item) => item.favorite == true).toList();
    }

    // Apply sorting
    switch (sortOption) {
      case GameCollectionSortOption.title:
        filtered.sort((a, b) => a.game.title.compareTo(b.game.title));
        break;
      case GameCollectionSortOption.publishYear:
        filtered.sort(
          (a, b) =>
              (b.game.publishYear ?? 0).compareTo(a.game.publishYear ?? 0),
        );
        break;
      case GameCollectionSortOption.rating:
        filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case GameCollectionSortOption.lastPlayed:
        filtered.sort((a, b) {
          final aDate = a.lastPlayed ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.lastPlayed ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case GameCollectionSortOption.playCount:
        filtered.sort((a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0));
        break;
    }

    return filtered;
  }
}
