part of 'game_search_bloc.dart';

abstract class GameSearchEvent extends Equatable {
  const GameSearchEvent();

  @override
  List<Object?> get props => [];
}

class GameSearchQueryChanged extends GameSearchEvent {
  const GameSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class GameSearchSourceChanged extends GameSearchEvent {
  const GameSearchSourceChanged(this.source);

  final String source;

  @override
  List<Object> get props => [source];
}

class GameSearchRequested extends GameSearchEvent {
  const GameSearchRequested();
}

class GameSearchResultsReceived extends GameSearchEvent {
  const GameSearchResultsReceived(this.results);

  final SearchResult results;

  @override
  List<Object> get props => [results];
}

class GameAddRequested extends GameSearchEvent {
  const GameAddRequested(this.game);

  final Game game;

  @override
  List<Object> get props => [game];
}

class GameConnectionStatusChanged extends GameSearchEvent {
  const GameConnectionStatusChanged(this.isConnected);

  final bool isConnected;

  @override
  List<Object> get props => [isConnected];
}
