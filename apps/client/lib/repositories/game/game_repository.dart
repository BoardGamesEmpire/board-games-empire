import 'dart:async';

import 'package:board_games_empire/blocs/error/error_bloc.dart';
import 'package:board_games_empire/data/api/api_exception.dart';
import 'package:board_games_empire/data/datasources/game_data_source.dart';
import 'package:board_games_empire/data/datasources/game_websocket_data_source.dart';

import '../../data/datasources/game_rest_data_source.dart';
import '../../models/game/game.dart';
import '../../models/game/game_collection.dart';
import '../../models/search_result.dart';
import '../../repositories/auth/user_context_provider.dart';
import '../../repositories/websocket/websocket_repository.dart';
import './abstract_game_repository.dart';

class GameRepository implements AbstractGameRepository {
  final GameRestDataSource _restDataSource;
  final WebSocketRepository _websocketRepository;
  final UserContextProvider _userContextProvider;
  final GameWebSocketDataSource _webSocketDataSource;
  final ErrorBloc _errorBloc;

  final _searchResultsController = StreamController<SearchResult>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  StreamSubscription? _wsConnectionSubscription;

  GameRepository({
    required GameWebSocketDataSource webSocketDataSource,
    required GameRestDataSource restDataSource,
    required WebSocketRepository websocketRepository,
    required UserContextProvider userContextProvider,
    required ErrorBloc errorBloc,
  }) : _restDataSource = restDataSource,
       _webSocketDataSource = webSocketDataSource,
       _websocketRepository = websocketRepository,
       _userContextProvider = userContextProvider,
       _errorBloc = errorBloc {
    _websocketRepository.subscribeToGameResults(_handleSearchResults);

    // Monitor connection status
    _wsConnectionSubscription = _websocketRepository.connectionStatus.listen(
      (isConnected) => _connectionStatusController.add(isConnected),
    );
  }

  GameDataSource get _activeDataSource {
    return _webSocketDataSource.isConnected
        ? _webSocketDataSource
        : _restDataSource;
  }

  void _handleSearchResults(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final searchResult = SearchResult.fromJson(payload);
      _searchResultsController.add(searchResult);
    }
  }

  @override
  Future<SearchResult> searchGames(String query, String externalSource) async {
    try {
      final result = await _activeDataSource.searchGames(query, externalSource);
      return result;
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        // Fallback to REST if WebSocket fails
        try {
          return _restDataSource.searchGames(query, externalSource);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported('Failed to search games: ${restError.toString()}'),
            );
          }

          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to search games: ${e.toString()}'),
        );
      }
      rethrow;
    }
  }

  @override
  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    try {
      return await _activeDataSource.getGameDetails(
        gameId,
        isExternal: isExternal,
        externalSource: externalSource,
      );
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.getGameDetails(
            gameId,
            isExternal: isExternal,
            externalSource: externalSource,
          );
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported(
                'Failed to get game details: ${restError.toString()}',
              ),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to get game details: ${e.toString()}'),
        );
      }

      rethrow;
    }
  }

  @override
  Future<Game> addGame(Game game) async {
    try {
      if (_webSocketDataSource.isConnected) {
        return await _websocketRepository.addGame(game);
      } else {
        return await _restDataSource.addGame(game);
      }
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        return await _restDataSource.addGame(game);
      }
      rethrow;
    }
  }

  @override
  Future<List<GameCollection>> getCollection() async {
    if (!_userContextProvider.isAuthenticated ||
        _userContextProvider.currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return getUserCollection(_userContextProvider.currentUserId!);
  }

  @override
  Future<List<GameCollection>> getUserCollection(String userId) async {
    try {
      final results = await _activeDataSource.getUserCollection(userId);
      return results
          .map((json) => GameCollection.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.getUserCollection(userId);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported('Failed to fetch games: ${restError.toString()}'),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(ErrorReported('Failed to fetch games: ${e.toString()}'));
      }
      rethrow;
    }
  }

  @override
  Future<void> addGameToCollection(String gameId, int quantity) async {
    try {
      await _activeDataSource.addGameToCollection(gameId, quantity);
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.removeGameFromCollection(gameId);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported('Failed to add game: ${restError.toString()}'),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(ErrorReported('Failed to add game: ${e.toString()}'));
      }

      rethrow;
    }
  }

  @override
  Future<void> removeGameFromCollection(String gameId) async {
    try {
      await _activeDataSource.removeGameFromCollection(gameId);
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        // Fallback to REST if WebSocket fails
        try {
          return _restDataSource.removeGameFromCollection(gameId);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported('Failed to remove game: ${restError.toString()}'),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(ErrorReported('Failed to remove game: ${e.toString()}'));
      }

      rethrow;
    }
  }

  @override
  Future<void> updateGameInCollection(
    String gameId, {
    int? quantity,
    int? rating,
    String? comment,
    bool? favorite,
  }) async {
    try {
      final result = await _activeDataSource.updateGameInCollection(
        gameId,
        quantity: quantity,
        rating: rating,
        comment: comment,
        favorite: favorite,
      );
      return result;
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return await _restDataSource.updateGameInCollection(
            gameId,
            quantity: quantity,
            rating: rating,
            comment: comment,
            favorite: favorite,
          );
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported('Failed to update game: ${restError.toString()}'),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(ErrorReported('Failed to update game: ${e.toString()}'));
      }

      rethrow;
    }
  }

  @override
  Stream<SearchResult> get searchResults => _searchResultsController.stream;

  @override
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  @override
  bool get isUsingWebSocket => _webSocketDataSource.isConnected;

  @override
  void dispose() {
    _websocketRepository.unsubscribeFromGameResults(
      (dynamic result) => _handleSearchResults(result as SearchResult),
    );
    _wsConnectionSubscription?.cancel();
    _searchResultsController.close();
    _connectionStatusController.close();
  }
}
