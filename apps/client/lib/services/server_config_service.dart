import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/config/server_config.dart';
import './platform_service.dart';
import '../config/environment_config.dart';
import '../di/injection.dart';
import './websocket/websocket_manager.dart';
import 'package:http_status/http_status.dart';

class ServerConfigService with ChangeNotifier {
  static const String _storageKey = 'server_configs';
  static const String _activeServerKey = 'active_server_id';

  List<ServerConfig> _serverConfigs = [];
  ServerConfig? _activeServer;
  bool _isInitialized = false;
  bool _isWebPlatform = false;

  List<ServerConfig> get serverConfigs => List.unmodifiable(_serverConfigs);
  ServerConfig? get activeServer => _activeServer;
  bool get isInitialized => _isInitialized;
  bool get hasServers => _serverConfigs.isNotEmpty;
  bool get isWeb => _isWebPlatform;

  WebSocketManager? _websocketManager;

  ServerConfigService({WebSocketManager? websocketManager}) {
    _websocketManager = websocketManager;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    _isWebPlatform = PlatformService.isWeb;

    if (_isWebPlatform) {
      await _initializeForWeb();
    } else {
      await _loadConfigs();
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _initializeForWeb() async {
    final webBaseUrl = PlatformService.webBaseUrl;

    final webServer = ServerConfig(
      id: 'web-server',
      name:
          'Web Server${kDebugMode ? ' (Port: ${EnvironmentConfig.apiPort})' : ''}',
      url: webBaseUrl,
      isActive: true,
      lastConnectedAt: DateTime.now(),
    );

    _serverConfigs = [webServer];
    _activeServer = webServer;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeServerKey, webServer.id);
    await prefs.setStringList(_storageKey, [jsonEncode(webServer.toJson())]);

    if (kDebugMode) {
      print('Web server initialized with URL: ${webServer.url}');
      print('Environment config: ${EnvironmentConfig.debugInfo}');
    }
  }

  Future<void> _loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = prefs.getStringList(_storageKey) ?? [];

    _serverConfigs =
        configsJson
            .map((json) => ServerConfig.fromJson(jsonDecode(json)))
            .toList();

    final activeServerId = prefs.getString(_activeServerKey);
    if (activeServerId != null) {
      _activeServer = _serverConfigs.firstWhere(
        (config) => config.id == activeServerId,
        orElse:
            () =>
                _serverConfigs.isNotEmpty
                    ? _serverConfigs.first
                    : throw Exception('No valid server configuration found'),
      );
    } else if (_serverConfigs.isNotEmpty) {
      _activeServer = _serverConfigs.first;
    }
  }

  Future<void> _saveConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson =
        _serverConfigs.map((config) => jsonEncode(config.toJson())).toList();

    await prefs.setStringList(_storageKey, configsJson);

    if (_activeServer != null) {
      await prefs.setString(_activeServerKey, _activeServer!.id);
    } else {
      await prefs.remove(_activeServerKey);
    }
  }

  Future<ServerConfig> addServer(String name, String url) async {
    if (_isWebPlatform) {
      throw Exception('Server configuration is fixed in web mode');
    }

    final sanitizedUrl = ServerConfig.sanitizeUrl(url);

    final existingServer = _serverConfigs.firstWhere(
      (s) => s.url == sanitizedUrl,
      orElse: () => ServerConfig(id: 'dummy-not-found', name: 'Dummy', url: ''),
    );

    if (existingServer.id != 'dummy-not-found') {
      throw Exception('A server with this URL already exists');
    }
    await validateServer(sanitizedUrl);

    final newConfig = ServerConfig(
      name: name.isNotEmpty ? name : _generateNameFromUrl(sanitizedUrl),
      url: sanitizedUrl,
      isActive: _serverConfigs.isEmpty,
      lastConnectedAt: DateTime.now(),
    );

    _serverConfigs.add(newConfig);
    _activeServer ??= newConfig;

    await _saveConfigs();
    notifyListeners();

    return newConfig;
  }

  Future<void> setActiveServer(String serverId) async {
    if (_isWebPlatform) {
      throw Exception('Server configuration is fixed in web mode');
    }

    final server = _serverConfigs.firstWhere(
      (config) => config.id == serverId,
      orElse: () => throw Exception('Server not found'),
    );

    // Update all servers to inactive, then set the selected one to active
    for (int i = 0; i < _serverConfigs.length; i++) {
      if (_serverConfigs[i].id == serverId) {
        _serverConfigs[i] = _serverConfigs[i].copyWith(
          isActive: true,
          lastConnectedAt: DateTime.now(),
        );
      } else {
        _serverConfigs[i] = _serverConfigs[i].copyWith(isActive: false);
      }
    }

    _activeServer = server.copyWith(
      isActive: true,
      lastConnectedAt: DateTime.now(),
    );

    await _saveConfigs();

    _websocketManager ??= getIt<WebSocketManager>();
    _websocketManager?.disconnect();

    notifyListeners();
  }

  Future<void> updateServer(
    String serverId, {
    String? name,
    String? url,
  }) async {
    if (_isWebPlatform) {
      throw Exception('Server configuration is fixed in web mode');
    }

    final index = _serverConfigs.indexWhere((config) => config.id == serverId);

    if (index == -1) {
      throw Exception('Server not found');
    }

    String? sanitizedUrl;
    if (url != null) {
      sanitizedUrl = ServerConfig.sanitizeUrl(url);

      final conflictingServer = _serverConfigs.firstWhere(
        (s) => s.id != serverId && s.url == sanitizedUrl,
        orElse:
            () => ServerConfig(id: 'dummy-not-found', name: 'Dummy', url: ''),
      );

      if (conflictingServer.id != 'dummy-not-found') {
        throw Exception('Another server with this URL already exists');
      }

      await validateServer(sanitizedUrl);
    }

    _serverConfigs[index] = _serverConfigs[index].copyWith(
      name: name,
      url: sanitizedUrl,
    );

    if (_activeServer?.id == serverId) {
      _activeServer = _serverConfigs[index];

      if (sanitizedUrl != null) {
        _websocketManager ??= getIt<WebSocketManager>();
        _websocketManager?.disconnect();
      }
    }

    await _saveConfigs();
    notifyListeners();
  }

  Future<void> removeServer(String serverId) async {
    if (_isWebPlatform) {
      throw Exception('Server configuration is fixed in web mode');
    }

    final index = _serverConfigs.indexWhere((config) => config.id == serverId);

    if (index == -1) {
      throw Exception('Server not found');
    }

    final isActiveServer = _serverConfigs[index].isActive;
    _serverConfigs.removeAt(index);

    if (isActiveServer) {
      _websocketManager ??= getIt<WebSocketManager>();
      _websocketManager?.disconnect();

      if (_serverConfigs.isNotEmpty) {
        await setActiveServer(_serverConfigs[0].id);
      } else {
        _activeServer = null;
      }
    }

    await _saveConfigs();
    notifyListeners();
  }

  Future<bool> validateServer(String url) async {
    try {
      if (_isWebPlatform) {
        return true;
      }

      final response = await http
          .get(
            Uri.parse('$url/health'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == HttpStatusCode.ok) {
        try {
          final data = jsonDecode(response.body);
          if (data.containsKey('status') && data['status'] == 'ok') {
            return true;
          }
        } catch (e) {
          if (response.body.contains('status') ||
              response.body.contains('ok')) {
            return true;
          }

          throw Exception('Invalid API response format');
        }
      }

      final baseResponse = await http
          .get(
            Uri.parse(url),
            headers: {'Accept': 'text/html,application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (baseResponse.statusCode >= HttpStatusCode.ok &&
          baseResponse.statusCode < HttpStatusCode.multipleChoices) {
        return true;
      }

      throw Exception('Invalid server response: ${response.statusCode}');
    } catch (e) {
      throw Exception('Could not connect to server: ${e.toString()}');
    }
  }

  String _generateNameFromUrl(String url) {
    String name = url.replaceFirst(RegExp(r'https?://'), '');

    name = name.replaceFirst(RegExp(r'^www\.'), '');
    name = name.split('/').first;

    return name;
  }
}
