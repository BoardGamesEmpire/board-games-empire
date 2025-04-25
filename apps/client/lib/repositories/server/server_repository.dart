import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../models/config/server_config.dart';
import '../../data/local/user_preferences.dart';
import '../../data/api/api_exception.dart';

class ServerRepository {
  final UserPreferences _userPreferences;
  List<ServerConfig> _serverConfigs = [];
  ServerConfig? _activeServer;
  bool _isInitialized = false;
  final bool _isWebPlatform;

  ServerRepository({
    required UserPreferences userPreferences,
    bool? isWebPlatform,
  }) : _userPreferences = userPreferences,
       _isWebPlatform = isWebPlatform ?? false;

  List<ServerConfig> get servers => List.unmodifiable(_serverConfigs);
  ServerConfig? get activeServer => _activeServer;
  bool get isInitialized => _isInitialized;
  bool get hasServers => _serverConfigs.isNotEmpty;
  bool get isWebPlatform => _isWebPlatform;

  Future<void> initialize() async {
    if (_isInitialized) return;

    if (_isWebPlatform) {
      await _initializeForWeb();
    } else {
      await _loadConfigs();
    }

    _isInitialized = true;
  }

  Future<void> _initializeForWeb() async {
    final webBaseUrl = _isWebPlatform ? await _getWebBaseUrl() : '';

    final webServer = ServerConfig(
      name: 'Web Server${kDebugMode ? ' (Port: 33333)' : ''}',
      url: webBaseUrl,
      isActive: true,
      lastConnectedAt: DateTime.now(),
    );

    _serverConfigs = [webServer];
    _activeServer = webServer;

    await _userPreferences.setCurrentServerId(webServer.id);
    await _userPreferences.saveServerConfigs(_serverConfigs);

    if (kDebugMode) {
      print('Web server initialized with URL: ${webServer.url}');
    }
  }

  Future<String> _getWebBaseUrl() async {
    // In a real implementation, this would get the base URL from the web environment
    // For now, we'll use a placeholder
    return '/api/v1';
  }

  Future<void> _loadConfigs() async {
    _serverConfigs = await _userPreferences.getServerConfigs();

    final activeServerId = await _userPreferences.getCurrentServerId();
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
    await _userPreferences.saveServerConfigs(_serverConfigs);

    if (_activeServer != null) {
      await _userPreferences.setCurrentServerId(_activeServer!.id);
    } else {
      await _userPreferences.removeCurrentServerId();
    }
  }

  Future<ServerConfig> addServer(String name, String url) async {
    if (_isWebPlatform) {
      throw ApiException(message: 'Server configuration is fixed in web mode');
    }

    final sanitizedUrl = ServerConfig.sanitizeUrl(url);

    final existingServer = _serverConfigs.firstWhere(
      (s) => s.url == sanitizedUrl,
      orElse: () => ServerConfig(id: '', name: '', url: ''),
    );

    if (existingServer.id.isNotEmpty) {
      throw ApiException(message: 'A server with this URL already exists');
    }

    // Validate before adding
    final isValid = await validateServer(sanitizedUrl);
    if (!isValid) {
      throw ApiException(message: 'Server validation failed');
    }

    final newConfig = ServerConfig(
      name: name.isNotEmpty ? name : _generateNameFromUrl(sanitizedUrl),
      url: sanitizedUrl,
      isActive: _serverConfigs.isEmpty,
      lastConnectedAt: DateTime.now(),
    );

    _serverConfigs.add(newConfig);
    _activeServer ??= newConfig;

    await _saveConfigs();
    return newConfig;
  }

  Future<void> setActiveServer(String serverId) async {
    if (_isWebPlatform) {
      throw ApiException(message: 'Server configuration is fixed in web mode');
    }

    final server = _serverConfigs.firstWhere(
      (config) => config.id == serverId,
      orElse: () => throw ApiException(message: 'Server not found'),
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
  }

  Future<void> updateServer(
    String serverId, {
    String? name,
    String? url,
  }) async {
    if (_isWebPlatform) {
      throw ApiException(message: 'Server configuration is fixed in web mode');
    }

    final index = _serverConfigs.indexWhere((config) => config.id == serverId);

    if (index == -1) {
      throw ApiException(message: 'Server not found');
    }

    String? sanitizedUrl;
    if (url != null) {
      sanitizedUrl = ServerConfig.sanitizeUrl(url);

      final conflictingServer = _serverConfigs.firstWhere(
        (s) => s.id != serverId && s.url == sanitizedUrl,
        orElse: () => ServerConfig(id: '', name: '', url: ''),
      );

      if (conflictingServer.id.isNotEmpty) {
        throw ApiException(
          message: 'Another server with this URL already exists',
        );
      }

      // Validate the new URL
      final isValid = await validateServer(sanitizedUrl);
      if (!isValid) {
        throw ApiException(message: 'Server validation failed');
      }
    }

    _serverConfigs[index] = _serverConfigs[index].copyWith(
      name: name,
      url: sanitizedUrl,
    );

    if (_activeServer?.id == serverId) {
      _activeServer = _serverConfigs[index];
    }

    await _saveConfigs();
  }

  Future<void> removeServer(String serverId) async {
    if (_isWebPlatform) {
      throw ApiException(message: 'Server configuration is fixed in web mode');
    }

    final index = _serverConfigs.indexWhere((config) => config.id == serverId);

    if (index == -1) {
      throw ApiException(message: 'Server not found');
    }

    final isActiveServer = _serverConfigs[index].isActive;
    _serverConfigs.removeAt(index);

    if (isActiveServer) {
      if (_serverConfigs.isNotEmpty) {
        await setActiveServer(_serverConfigs[0].id);
      } else {
        _activeServer = null;
      }
    }

    await _saveConfigs();
  }

  Future<bool> validateServer(String url) async {
    try {
      if (_isWebPlatform) {
        return true; // Always valid in web mode
      }

      final response = await http
          .get(
            Uri.parse('$url/health'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
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
        }
      }

      // Try accessing the base URL if health check fails
      final baseResponse = await http
          .get(
            Uri.parse(url),
            headers: {'Accept': 'text/html,application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return baseResponse.statusCode >= 200 && baseResponse.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  Future<List<ServerConfig>> getServers() async {
    return _serverConfigs;
  }

  String _generateNameFromUrl(String url) {
    String name = url.replaceFirst(RegExp(r'https?://'), '');
    name = name.replaceFirst(RegExp(r'^www\.'), '');
    name = name.split('/').first;
    return name;
  }
}
