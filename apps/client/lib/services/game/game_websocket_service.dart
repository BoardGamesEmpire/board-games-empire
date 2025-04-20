import 'dart:async';
import '../../models/game/game.dart';
import '../../models/search_result.dart';
import '../websocket/websocket_manager.dart';

class GameWebSocketService {
  final WebSocketManager _socketManager;

  final _searchResultsController = StreamController<SearchResult>.broadcast();

  GameWebSocketService({WebSocketManager? socketManager})
    : _socketManager = socketManager ?? WebSocketManager() {
    _socketManager.subscribe('searchResults', _handleSearchResults);
    _socketManager.subscribe('gameAdded', _handleGameAdded);
  }

  void _handleSearchResults(dynamic payload) {
    final searchResult = SearchResult.fromJson(payload);
    _searchResultsController.add(searchResult);
  }

  void _handleGameAdded(dynamic payload) {
    print('Game added: ${payload['title']}');
  }

  Future<SearchResult> searchGames(String query, String externalSource) async {
    if (!_socketManager.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _socketManager.sendRequest<Map<String, dynamic>>(
        'searchGames',
        {'query': query, 'externalSource': externalSource},
      );

      return SearchResult.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    if (!_socketManager.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _socketManager.sendRequest<Map<String, dynamic>>(
        'getGameDetails',
        {
          'gameId': gameId,
          'isExternal': isExternal,
          'externalSource': externalSource,
        },
      );

      return Game.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Game> addGame(Game game) async {
    if (!_socketManager.isConnected) {
      throw Exception('WebSocket not connected');
    }

    try {
      final result = await _socketManager.sendRequest<Map<String, dynamic>>(
        'addGame',
        game.toJson(),
      );

      return Game.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Stream<SearchResult> get searchResultsStream =>
      _searchResultsController.stream;

  void dispose() {
    _socketManager.unsubscribe('searchResults', _handleSearchResults);
    _socketManager.unsubscribe('gameAdded', _handleGameAdded);
    _searchResultsController.close();
  }
}
