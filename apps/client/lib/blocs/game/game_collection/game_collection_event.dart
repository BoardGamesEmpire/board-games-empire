part of 'game_collection_bloc.dart';

abstract class GameCollectionEvent extends Equatable {
  const GameCollectionEvent();

  @override
  List<Object?> get props => [];
}

class GameCollectionRequested extends GameCollectionEvent {
  const GameCollectionRequested();

  @override
  List<Object?> get props => [];
}

class GameCollectionGameAdded extends GameCollectionEvent {
  final String gameId;
  final int quantity;

  const GameCollectionGameAdded(this.gameId, {this.quantity = 1});

  @override
  List<Object?> get props => [gameId, quantity];
}

class GameCollectionGameRemoved extends GameCollectionEvent {
  final String gameId;

  const GameCollectionGameRemoved(this.gameId);

  @override
  List<Object?> get props => [gameId];
}

class GameCollectionGameUpdated extends GameCollectionEvent {
  final String gameId;
  final int? quantity;
  final int? rating;
  final String? comment;
  final bool? favorite;

  const GameCollectionGameUpdated(
    this.gameId, {
    this.quantity,
    this.rating,
    this.comment,
    this.favorite,
  });

  @override
  List<Object?> get props => [gameId, quantity, rating, comment, favorite];
}

class GameCollectionFiltered extends GameCollectionEvent {
  final String? query;
  final bool? onlyFavorites;

  const GameCollectionFiltered({this.query, this.onlyFavorites});

  @override
  List<Object?> get props => [query, onlyFavorites];
}

class GameCollectionSorted extends GameCollectionEvent {
  final GameCollectionSortOption sortOption;

  const GameCollectionSorted(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}
