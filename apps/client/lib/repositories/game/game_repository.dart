import 'dart:async';

import 'package:board_games_empire/repositories/auth/user_context_provider.dart';

import '../../data/datasources/game_data_source.dart';
import '../../data/datasources/game_rest_data_source.dart';
import '../../data/datasources/game_websocket_data_source.dart';
import '../../services/websocket/websocket_manager.dart';
import '../../models/game/game.dart';
import '../../models/game/game_collection.dart';
import '../../models/search_result.dart';
import './abstract_game_repository.dart';

class GameRepository implements AbstractGameRepository {
  final GameRestDataSource _restDataSource;
  final GameWebSocketDataSource _webSocketDataSource;
  final WebSocketManager _webSocketManager;
  final UserContextProvider _userContextProvider;

  final _searchResultsController = StreamController<SearchResult>.broadcast();

  GameRepository({
    required GameRestDataSource restDataSource,
    required GameWebSocketDataSource webSocketDataSource,
    required WebSocketManager webSocketManager,
    required UserContextProvider userContextProvider,
  }) : _restDataSource = restDataSource,
       _webSocketDataSource = webSocketDataSource,
       _webSocketManager = webSocketManager,
       _userContextProvider = userContextProvider {
    _webSocketManager.subscribe('searchResults', _handleSearchResults);
  }

  void _handleSearchResults(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final searchResult = SearchResult.fromJson(payload);
      _searchResultsController.add(searchResult);
    }
  }

  GameDataSource get _activeDataSource {
    return _webSocketManager.isConnected
        ? _webSocketDataSource
        : _restDataSource;
  }

  @override
  Future<SearchResult> searchGames(String query, String externalSource) async {
    try {
      final result = await _activeDataSource.searchGames(query, externalSource);
      return result;
    } catch (e) {
      if (_webSocketManager.isConnected) {
        // Fallback to REST if WebSocket fails
        return _restDataSource.searchGames(query, externalSource);
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
      if (_webSocketManager.isConnected) {
        return _restDataSource.getGameDetails(
          gameId,
          isExternal: isExternal,
          externalSource: externalSource,
        );
      }
      rethrow;
    }
  }

  @override
  Future<Game> addGame(Game game) async {
    try {
      return await _activeDataSource.addGame(game);
    } catch (e) {
      if (_webSocketManager.isConnected) {
        return _restDataSource.addGame(game);
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
      return await _activeDataSource.getUserCollection(userId);
    } catch (e) {
      if (_webSocketManager.isConnected) {
        return _restDataSource.getUserCollection(userId);
      }
      rethrow;
    }
  }

  @override
  Future<void> addGameToCollection(String gameId, int quantity) async {
    try {
      await _activeDataSource.addGameToCollection(gameId, quantity);
    } catch (e) {
      if (_webSocketManager.isConnected) {
        await _restDataSource.addGameToCollection(gameId, quantity);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> removeGameFromCollection(String gameId) async {
    try {
      await _activeDataSource.removeGameFromCollection(gameId);
    } catch (e) {
      if (_webSocketManager.isConnected) {
        await _restDataSource.removeGameFromCollection(gameId);
      } else {
        rethrow;
      }
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
      await _activeDataSource.updateGameInCollection(
        gameId,
        quantity: quantity,
        rating: rating,
        comment: comment,
        favorite: favorite,
      );
    } catch (e) {
      if (_webSocketManager.isConnected) {
        await _restDataSource.updateGameInCollection(
          gameId,
          quantity: quantity,
          rating: rating,
          comment: comment,
          favorite: favorite,
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  Stream<SearchResult> get searchResults => _searchResultsController.stream;

  @override
  bool get isUsingWebSocket => _webSocketManager.isConnected;

  @override
  void dispose() {
    _webSocketManager.unsubscribe('searchResults', _handleSearchResults);
    _searchResultsController.close();
  }
}
