part of 'game_search_bloc.dart';

enum GameSearchStatus { initial, loading, success, failure }

class GameSearchState extends Equatable {
  const GameSearchState({
    this.status = GameSearchStatus.initial,
    this.query = '',
    this.externalSource = 'BoardGameGeek',
    this.searchResult,
    this.addedGame,
    this.addingGameId,
    this.error,
  });

  final GameSearchStatus status;
  final String query;
  final String externalSource;
  final SearchResult? searchResult;
  final Game? addedGame;
  final String? addingGameId;
  final String? error;

  bool get isInitial => status == GameSearchStatus.initial;
  bool get isLoading => status == GameSearchStatus.loading;
  bool get isSuccess => status == GameSearchStatus.success;
  bool get isFailure => status == GameSearchStatus.failure;
  bool get hasResults => searchResult != null;
  bool get hasInternalResults =>
      searchResult?.internalResults.isNotEmpty ?? false;
  bool get hasExternalResults =>
      searchResult?.externalResults.isNotEmpty ?? false;
  bool get hasNoResults =>
      hasResults && !hasInternalResults && !hasExternalResults;
  bool get isAddingGame => addingGameId != null;

  List<Game> get internalResults => searchResult?.internalResults ?? [];
  List<Game> get externalResults => searchResult?.externalResults ?? [];

  GameSearchState copyWith({
    GameSearchStatus? status,
    String? query,
    String? externalSource,
    SearchResult? searchResult,
    Game? addedGame,
    String? addingGameId,
    String? error,
  }) {
    return GameSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      externalSource: externalSource ?? this.externalSource,
      searchResult: searchResult ?? this.searchResult,
      addedGame: addedGame ?? this.addedGame,
      addingGameId: addingGameId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    externalSource,
    searchResult,
    addedGame,
    addingGameId,
    error,
  ];
}
