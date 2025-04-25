import '../websocket/websocket_client.dart';
import '../../models/game/game.dart';
import '../../models/game/game_collection.dart';
import '../../models/search_result.dart';
import './game_data_source.dart';

class GameWebSocketDataSource implements GameDataSource {
  final WebSocketClient _webSocketClient;

  bool get isConnected => _webSocketClient.isConnected;

  GameWebSocketDataSource({required WebSocketClient webSocketClient})
    : _webSocketClient = webSocketClient;

  @override
  Future<SearchResult> searchGames(String query, String externalSource) async {
    final result = await _webSocketClient.sendRequest<Map<String, dynamic>>(
      'searchGames',
      {'query': query, 'externalSource': externalSource},
      timeout: const Duration(seconds: 30),
    );

    return SearchResult.fromJson(result);
  }

  @override
  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    final result = await _webSocketClient.sendRequest<Map<String, dynamic>>(
      'getGameDetails',
      {
        'gameId': gameId,
        'isExternal': isExternal,
        'externalSource': externalSource,
      },
      timeout: const Duration(seconds: 20),
    );

    return Game.fromJson(result);
  }

  @override
  Future<Game> addGame(Game game) async {
    final result = await _webSocketClient.sendRequest<Map<String, dynamic>>(
      'addGame',
      game.toJson(),
      timeout: const Duration(seconds: 20),
    );

    return Game.fromJson(result);
  }

  @override
  Future<List<GameCollection>> getUserCollection(String userId) async {
    final result = await _webSocketClient.sendRequest<List<dynamic>>(
      'getUserCollection',
      {'userId': userId},
      timeout: const Duration(seconds: 20),
    );

    return result
        .map((json) => GameCollection.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addGameToCollection(String gameId, int quantity) async {
    await _webSocketClient.sendRequest<void>('addGameToCollection', {
      'gameId': gameId,
      'quantity': quantity,
    }, timeout: const Duration(seconds: 20));
  }

  @override
  Future<void> removeGameFromCollection(String gameId) async {
    await _webSocketClient.sendRequest<void>('removeGameFromCollection', {
      'gameId': gameId,
    }, timeout: const Duration(seconds: 20));
  }

  @override
  Future<void> updateGameInCollection(
    String gameId, {
    int? quantity,
    int? rating,
    String? comment,
    bool? favorite,
  }) async {
    final updateData = {
      'gameId': gameId,
      if (quantity != null) 'quantity': quantity,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (favorite != null) 'favorite': favorite,
    };

    await _webSocketClient.sendRequest<void>(
      'updateGameInCollection',
      updateData,
      timeout: const Duration(seconds: 20),
    );
  }
}
