import 'package:board_games_empire/models/game/game_gateway.dart';
import 'package:board_games_empire/data/websocket/websocket_client.dart';
import 'package:board_games_empire/data/api/api_exception.dart';

import 'game_gateway_source.dart';

class GameGatewayWebSocket extends GameGatewaySource {
  final WebSocketClient _webSocketClient;

  bool get isConnected => _webSocketClient.isConnected;

  GameGatewayWebSocket({required WebSocketClient webSocketClient})
    : _webSocketClient = webSocketClient;

  /// Fetches all game gateways
  @override
  Future<List<GameGateway>> getGameGateways() async {
    if (!isConnected) {
      throw ApiException(message: 'WebSocket connection not established');
    }

    try {
      final response = await _webSocketClient.sendRequest(
        'game-gateways.getAll',
        {},
        timeout: const Duration(seconds: 5),
      );

      final List<dynamic> data = response['data'];
      return data.map((json) => GameGateway.fromJson(json)).toList();
    } catch (e) {
      throw ApiException(message: 'WebSocket error: ${e.toString()}');
    }
  }

  /// Creates a new game gateway
  @override
  Future<GameGateway> createGameGateway(GameGateway gateway) async {
    if (!isConnected) {
      throw ApiException(message: 'WebSocket connection not established');
    }

    try {
      final response = await _webSocketClient.sendRequest(
        'game-gateways.create',
        gateway.toJson(),
      );

      return GameGateway.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: 'WebSocket error: ${e.toString()}');
    }
  }

  /// Updates an existing game gateway
  @override
  Future<GameGateway> updateGameGateway(GameGateway gateway) async {
    if (!isConnected) {
      throw ApiException(message: 'WebSocket connection not established');
    }

    try {
      final response = await _webSocketClient.sendRequest(
        'game-gateways.update',
        {'id': gateway.id, ...gateway.toJson()},
      );

      return GameGateway.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: 'WebSocket error: ${e.toString()}');
    }
  }

  /// Deletes a game gateway
  @override
  Future<void> deleteGameGateway(String id) async {
    if (!isConnected) {
      throw ApiException(message: 'WebSocket connection not established');
    }

    try {
      await _webSocketClient.sendRequest('game-gateways.delete', {'id': id});
    } catch (e) {
      throw ApiException(message: 'WebSocket error: ${e.toString()}');
    }
  }

  /// Patch a game gateway
  @override
  Future<GameGateway> patchGameGateway(
    String id,
    Map<String, dynamic> updates,
  ) async {
    if (!isConnected) {
      throw ApiException(message: 'WebSocket connection not established');
    }

    try {
      final response = await _webSocketClient.sendRequest(
        'game-gateways.patch',
        {'id': id, ...updates},
      );

      return GameGateway.fromJson(response['data']);
    } catch (e) {
      throw ApiException(message: 'WebSocket error: ${e.toString()}');
    }
  }
}
