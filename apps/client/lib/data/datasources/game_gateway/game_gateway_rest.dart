import 'package:board_games_empire/data/api/game_gateway_api.dart';
import 'package:board_games_empire/models/game/game_gateway.dart';

import 'game_gateway_source.dart';

class GameGatewayRest extends GameGatewaySource {
  final GameGatewayApi _api;

  GameGatewayRest({required GameGatewayApi api}) : _api = api;

  @override
  Future<List<GameGateway>> getGameGateways() async {
    return _api.getGameGateways();
  }

  @override
  Future<GameGateway> createGameGateway(GameGateway gateway) async {
    return _api.createGameGateway(gateway);
  }

  @override
  Future<GameGateway> updateGameGateway(GameGateway gateway) async {
    return _api.updateGameGateway(gateway);
  }

  @override
  Future<void> deleteGameGateway(String id) async {
    await _api.deleteGameGateway(id);
  }

  @override
  Future<GameGateway> patchGameGateway(
    String id,
    Map<String, dynamic> data,
  ) async {
    return _api.patchGameGateway(id, data);
  }
}
