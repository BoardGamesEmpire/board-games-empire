import 'package:board_games_empire/models/game/game_gateway.dart';

abstract class GameGatewaySource {
  Future<List<GameGateway>> getGameGateways();
  Future<GameGateway> createGameGateway(GameGateway gateway);
  Future<GameGateway> updateGameGateway(GameGateway gateway);
  Future<GameGateway> patchGameGateway(String id, Map<String, dynamic> data);
  Future<void> deleteGameGateway(String id);
}
