part of 'game_collection_bloc.dart';

enum GameCollectionStatus { initial, loading, success, failure }

enum GameCollectionSortOption {
  title,
  publishYear,
  rating,
  lastPlayed,
  playCount,
}

class GameCollectionState extends Equatable {
  final GameCollectionStatus status;
  final List<GameCollection> games;
  final List<GameCollection> filteredGames;
  final String? errorMessage;
  final String? searchQuery;
  final bool? onlyFavorites;
  final GameCollectionSortOption sortOption;

  const GameCollectionState({
    this.status = GameCollectionStatus.initial,
    this.games = const [],
    this.filteredGames = const [],
    this.errorMessage,
    this.searchQuery,
    this.onlyFavorites = false,
    this.sortOption = GameCollectionSortOption.title,
  });

  GameCollectionState copyWith({
    GameCollectionStatus? status,
    List<GameCollection>? games,
    List<GameCollection>? filteredGames,
    String? errorMessage,
    String? searchQuery,
    bool? onlyFavorites,
    GameCollectionSortOption? sortOption,
  }) {
    return GameCollectionState(
      status: status ?? this.status,
      games: games ?? this.games,
      filteredGames: filteredGames ?? this.filteredGames,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [
    status,
    games,
    filteredGames,
    errorMessage,
    searchQuery,
    onlyFavorites,
    sortOption,
  ];

  bool get isInitial => status == GameCollectionStatus.initial;
  bool get isLoading => status == GameCollectionStatus.loading;
  bool get isSuccess => status == GameCollectionStatus.success;
  bool get isFailure => status == GameCollectionStatus.failure;
  bool get isEmpty => filteredGames.isEmpty;
}
