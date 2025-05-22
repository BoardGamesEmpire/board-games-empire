import 'dart:convert';

import 'package:board_games_empire/data/api/api_exception.dart';
import 'package:board_games_empire/data/api/base_api.dart';
import 'package:board_games_empire/models/game/game_gateway.dart';

class GameGatewayApi extends BaseApi {
  GameGatewayApi({required super.baseUrl, required super.authRepo});

  final apiPrefix = '/game-gateways';

  Future<List<GameGateway>> getGameGateways() async {
    try {
      final List<dynamic> gameGateways = await get(apiPrefix);
      return gameGateways.map((json) => GameGateway.fromJson(json)).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<GameGateway> createGameGateway(GameGateway gateway) async {
    try {
      final data = await post(
        apiPrefix,
        body: jsonEncode(gateway.toJson(create: true)),
      );

      return GameGateway.fromJson(data);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<GameGateway> updateGameGateway(GameGateway gateway) async {
    try {
      final data = await put(
        '$apiPrefix/${gateway.id}',
        body: jsonEncode(gateway.toJson()),
      );

      return GameGateway.fromJson(data);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<void> deleteGameGateway(String id) async {
    try {
      return await delete('$apiPrefix/$id');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<GameGateway> patchGameGateway(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await patch('$apiPrefix/$id', body: jsonEncode(data));
      return GameGateway.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }
}
