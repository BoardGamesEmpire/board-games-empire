import 'package:board_games_empire/blocs/error/error_bloc.dart';
import 'package:board_games_empire/data/api/api_exception.dart';
import 'package:board_games_empire/data/datasources/game_gateway/game_gateway_rest.dart';
import 'package:board_games_empire/data/datasources/game_gateway/game_gateway_source.dart';
import 'package:board_games_empire/data/datasources/game_gateway/game_gateway_websocket.dart';
import 'package:board_games_empire/models/game/game_gateway.dart';

class GameGatewayRepository {
  final GameGatewayRest _restDataSource;
  final GameGatewayWebSocket _webSocketDataSource;
  final ErrorBloc _errorBloc;

  GameGatewayRepository({
    required GameGatewayRest gameGatewayRest,
    required GameGatewayWebSocket gameGatewayWebSocket,
    required ErrorBloc errorBloc,
  }) : _restDataSource = gameGatewayRest,
       _webSocketDataSource = gameGatewayWebSocket,
       _errorBloc = errorBloc;

  GameGatewaySource get _activeDataSource {
    return _webSocketDataSource.isConnected
        ? _webSocketDataSource
        : _restDataSource;
  }

  Future<List<GameGateway>> getGameGateways() async {
    try {
      return await _activeDataSource.getGameGateways();
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.getGameGateways();
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported(
                'Failed to fetch game gateways: ${restError.toString()}',
              ),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to fetch game gateways: ${e.toString()}'),
        );
      }
      rethrow;
    }
  }

  Future<GameGateway> createGameGateway(GameGateway gateway) async {
    try {
      final result = await _activeDataSource.createGameGateway(gateway);
      return result;
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.createGameGateway(gateway);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported(
                'Failed to create game gateway: ${restError.toString()}',
              ),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to create game gateway: ${e.toString()}'),
        );
      }
      rethrow;
    }
  }

  Future<GameGateway> updateGameGateway(GameGateway gateway) async {
    try {
      final result = await _activeDataSource.updateGameGateway(gateway);
      return result;
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.updateGameGateway(gateway);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported(
                'Failed to update game gateway: ${restError.toString()}',
              ),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to update game gateway: ${e.toString()}'),
        );
      }
      rethrow;
    }
  }

  Future<void> deleteGameGateway(String id) async {
    try {
      await _activeDataSource.deleteGameGateway(id);
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.deleteGameGateway(id);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported(
                'Failed to delete game gateway: ${restError.toString()}',
              ),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to delete game gateway: ${e.toString()}'),
        );
      }
      rethrow;
    }
  }

  Future<GameGateway> patchGameGateway(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _activeDataSource.patchGameGateway(id, data);
      return result;
    } catch (e) {
      if (_webSocketDataSource.isConnected) {
        try {
          return _restDataSource.patchGameGateway(id, data);
        } catch (restError) {
          if (restError is ApiException) {
            restError.report(_errorBloc);
          } else {
            _errorBloc.add(
              ErrorReported(
                'Failed to patch game gateway: ${restError.toString()}',
              ),
            );
          }
          rethrow;
        }
      }

      if (e is ApiException) {
        e.report(_errorBloc);
      } else {
        _errorBloc.add(
          ErrorReported('Failed to patch game gateway: ${e.toString()}'),
        );
      }
      rethrow;
    }
  }
}
