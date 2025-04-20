import '../api/game_api.dart';
import './game_data_source.dart';
import '../../models/game/game.dart';
import '../../models/game/game_collection.dart';
import '../../models/search_result.dart';

class GameRestDataSource implements GameDataSource {
  final GameApi _gameApi;

  GameRestDataSource({required GameApi gameApi}) : _gameApi = gameApi;

  @override
  Future<SearchResult> searchGames(String query, String externalSource) async {
    return await _gameApi.searchGames(query, externalSource);
  }

  @override
  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    return await _gameApi.getGameDetails(
      gameId,
      isExternal: isExternal,
      externalSource: externalSource,
    );
  }

  @override
  Future<Game> addGame(Game game) async {
    return await _gameApi.addGame(game);
  }

  @override
  Future<List<GameCollection>> getUserCollection(String userId) async {
    final response = await _gameApi.getUserCollection(userId);
    return response.map((json) => GameCollection.fromJson(json)).toList();
  }

  @override
  Future<void> addGameToCollection(String gameId, int quantity) async {
    await _gameApi.addGameToCollection(gameId, quantity);
  }

  @override
  Future<void> removeGameFromCollection(String gameId) async {
    await _gameApi.removeGameFromCollection(gameId);
  }

  @override
  Future<void> updateGameInCollection(
    String gameId, {
    int? quantity,
    int? rating,
    String? comment,
    bool? favorite,
  }) async {
    await _gameApi.updateGameInCollection(
      gameId,
      quantity: quantity,
      rating: rating,
      comment: comment,
      favorite: favorite,
    );
  }
}
