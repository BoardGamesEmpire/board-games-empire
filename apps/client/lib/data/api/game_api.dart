import '../../models/search_result.dart';
import '../../models/game/game.dart';
import './api_exception.dart';
import './base_api.dart';

class GameApi extends BaseApi {
  GameApi({required super.baseUrl, required super.authRepo});

  final apiPrefix = '/games';

  Future<SearchResult> searchGames(String query, String externalSource) async {
    try {
      final response = await get(
        '$apiPrefix/search?query=$query&externalSource=$externalSource',
      );

      return SearchResult.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to search games: ${e.toString()}');
    }
  }

  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    try {
      String url = '$apiPrefix/$gameId';
      if (isExternal) {
        url += '?isExternal=true&externalSource=$externalSource';
      }

      final response = await get(url);

      return Game.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to get game details: ${e.toString()}',
      );
    }
  }

  Future<Game> addGame(Game game) async {
    try {
      final response = await post(apiPrefix, body: game.toJson());

      return Game.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to add game: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserCollection(String userId) async {
    try {
      final response = await get('/users/$userId/collection');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        throw ApiException(message: 'Invalid response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to get user collection: ${e.toString()}',
      );
    }
  }

  Future<void> addGameToCollection(String gameId, int quantity) async {
    try {
      await post(
        '/games/collection',
        body: {'gameId': gameId, 'quantity': quantity},
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to add game to collection: ${e.toString()}',
      );
    }
  }

  Future<void> removeGameFromCollection(String gameId) async {
    try {
      await delete('/games/collection/$gameId');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to remove game from collection: ${e.toString()}',
      );
    }
  }

  Future<void> updateGameInCollection(
    String gameId, {
    int? quantity,
    int? rating,
    String? comment,
    bool? favorite,
  }) async {
    try {
      final updateData = {
        if (quantity != null) 'quantity': quantity,
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment,
        if (favorite != null) 'favorite': favorite,
      };

      await put('/games/collection/$gameId', body: updateData);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to update game in collection: ${e.toString()}',
      );
    }
  }
}
