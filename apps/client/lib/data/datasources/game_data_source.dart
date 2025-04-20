import '../../models/game/game.dart';
import '../../models/game/game_collection.dart';
import '../../models/search_result.dart';

abstract class GameDataSource {
  Future<SearchResult> searchGames(String query, String externalSource);
  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal,
    String? externalSource,
  });
  Future<Game> addGame(Game game);
  Future<List<GameCollection>> getUserCollection(String userId);
  Future<void> addGameToCollection(String gameId, int quantity);
  Future<void> removeGameFromCollection(String gameId);
  Future<void> updateGameInCollection(
    String gameId, {
    int? quantity,
    int? rating,
    String? comment,
    bool? favorite,
  });
}
