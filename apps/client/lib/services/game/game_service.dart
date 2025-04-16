import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../websocket/websocket_manager.dart';
import '../server_config_service.dart';
import '../jwt_interceptor.dart';
import '../../di/injection.dart';
import '../../models/game.dart';
import '../../models/search_result.dart';

class GameService {
  late final WebSocketManager _socketManager;
  late final ServerConfigService _serverConfigService;
  late final JwtHttpClient _httpClient;

  final _searchResultsController = StreamController<SearchResult>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  bool _useWebSocket = true;

  GameService({
    WebSocketManager? socketManager,
    ServerConfigService? serverConfigService,
    JwtHttpClient? httpClient,
  }) {
    _socketManager = socketManager ?? getIt<WebSocketManager>();
    _serverConfigService = serverConfigService ?? getIt<ServerConfigService>();
    _httpClient = httpClient ?? getIt<JwtHttpClient>();

    _initService();
  }

  void _initService() {
    _socketManager.subscribe('searchResults', _handleSearchResults);
    _socketManager.subscribe('gameAdded', _handleGameAdded);

    _socketManager.statusStream.listen((connected) {
      _useWebSocket = connected;
      _connectionStatusController.add(connected);
    });

    _serverConfigService.addListener(_handleServerChange);

    if (_serverConfigService.isInitialized &&
        _serverConfigService.activeServer != null) {
      _initConnection();
    }
  }

  void _handleServerChange() {
    if (_serverConfigService.activeServer != null) {
      final activeServer = _serverConfigService.activeServer!;

      if (_socketManager.currentServerId != activeServer.id) {
        _initConnection();
      }
    }
  }

  Future<void> _initConnection() async {
    if (_serverConfigService.activeServer == null) {
      return;
    }

    final server = _serverConfigService.activeServer!;

    bool connected = await _socketManager.connect(server.url, server.id);
    _useWebSocket = connected;
    _connectionStatusController.add(connected);
  }

  void _handleSearchResults(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final searchResult = SearchResult.fromJson(payload);
      _searchResultsController.add(searchResult);
    }
  }

  void _handleGameAdded(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      if (kDebugMode) {
        print('Game added: ${payload['title']}');
      }
    }
  }

  Future<void> reconnect() async {
    await _initConnection();
  }

  Future<SearchResult> searchGames(String query, String externalSource) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    try {
      if (_useWebSocket) {
        final result = await _socketManager.sendRequest<Map<String, dynamic>>(
          'searchGames',
          {'query': query, 'externalSource': externalSource},
          timeout: const Duration(seconds: 30),
        );

        return SearchResult.fromJson(result);
      } else {
        final response = await _httpClient.get(
          Uri.parse(
            '/games/search?query=$query&externalSource=$externalSource',
          ),
        );

        if (response.statusCode == 200) {
          final searchResult = SearchResult.fromJson(jsonDecode(response.body));
          _searchResultsController.add(searchResult);
          return searchResult;
        } else {
          throw Exception('Failed to search games: ${response.body}');
        }
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        _connectionStatusController.add(false);
        return searchGames(query, externalSource);
      }
      rethrow;
    }
  }

  Future<Game> getGameDetails(
    String gameId, {
    bool isExternal = false,
    String? externalSource,
  }) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    try {
      if (_useWebSocket) {
        final result = await _socketManager.sendRequest<Map<String, dynamic>>(
          'getGameDetails',
          {
            'gameId': gameId,
            'isExternal': isExternal,
            'externalSource': externalSource,
          },
          timeout: const Duration(seconds: 20),
        );

        return Game.fromJson(result);
      } else {
        String path = '/games/$gameId';
        if (isExternal) {
          path += '?isExternal=true&externalSource=$externalSource';
        }

        final response = await _httpClient.get(Uri.parse(path));

        if (response.statusCode == 200) {
          return Game.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to get game details: ${response.body}');
        }
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        _connectionStatusController.add(false);
        return getGameDetails(
          gameId,
          isExternal: isExternal,
          externalSource: externalSource,
        );
      }
      rethrow;
    }
  }

  Future<Game> addGame(Game game) async {
    if (_serverConfigService.activeServer == null) {
      throw Exception('No active server configured');
    }

    try {
      if (_useWebSocket) {
        final result = await _socketManager.sendRequest<Map<String, dynamic>>(
          'addGame',
          game.toJson(),
          timeout: const Duration(seconds: 20),
        );

        return Game.fromJson(result);
      } else {
        final response = await _httpClient.post(
          Uri.parse('/games'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(game.toJson()),
        );

        if (response.statusCode == 201) {
          return Game.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to add game: ${response.body}');
        }
      }
    } catch (e) {
      if (_useWebSocket) {
        _useWebSocket = false;
        _connectionStatusController.add(false);
        return addGame(game);
      }
      rethrow;
    }
  }

  Stream<SearchResult> get searchResultsStream =>
      _searchResultsController.stream;

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  bool get isUsingWebSocket => _useWebSocket;

  void dispose() {
    _socketManager.unsubscribe('searchResults', _handleSearchResults);
    _socketManager.unsubscribe('gameAdded', _handleGameAdded);
    _serverConfigService.removeListener(_handleServerChange);
    _searchResultsController.close();
    _connectionStatusController.close();
  }
}
