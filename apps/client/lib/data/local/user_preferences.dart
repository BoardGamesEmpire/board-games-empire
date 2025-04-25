import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/config/server_config.dart';
import '../../models/user.dart';

class UserPreferences {
  static const String _currentServerIdKey = 'current_server_id';
  static const String _serversKey = 'server_configs';

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<String?> getCurrentServerId() async {
    await init();
    return _prefs.getString(_currentServerIdKey);
  }

  Future<void> setCurrentServerId(String serverId) async {
    await init();
    await _prefs.setString(_currentServerIdKey, serverId);
  }

  Future<void> removeCurrentServerId() async {
    await init();
    await _prefs.remove(_currentServerIdKey);
  }

  Future<void> saveUserData(String serverId, User user) async {
    await init();
    await _prefs.setString(
      'server_${serverId}_user_data',
      jsonEncode(user.toJson()),
    );
  }

  Future<Map<String, dynamic>?> getUserData(String serverId) async {
    await init();
    final userData = _prefs.getString('server_${serverId}_user_data');
    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> removeUserData(String serverId) async {
    await init();
    await _prefs.remove('server_${serverId}_user_data');
    await _prefs.remove('server_${serverId}_current_session_id');
  }

  Future<List<ServerConfig>> getServerConfigs() async {
    await init();
    final configsJson = _prefs.getStringList(_serversKey) ?? [];
    return configsJson
        .map((json) => ServerConfig.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveServerConfigs(List<ServerConfig> configs) async {
    await init();
    final configsJson =
        configs.map((config) => jsonEncode(config.toJson())).toList();
    await _prefs.setStringList(_serversKey, configsJson);
  }

  Future<String?> getServerUrl(String serverId) async {
    await init();

    final configs = await getServerConfigs();
    final server = configs.firstWhere(
      (config) => config.id == serverId,
      orElse: () => ServerConfig(id: '', name: '', url: ''),
    );
    return server.id.isNotEmpty ? server.url : null;
  }

  Future<void> saveSessionId(String serverId, String sessionId) async {
    await init();
    await _prefs.setString('server_${serverId}_current_session_id', sessionId);
  }

  Future<String?> getSessionId(String serverId) async {
    await init();
    return _prefs.getString('server_${serverId}_current_session_id');
  }

  Future<Map<String, dynamic>> getAll() async {
    await init();
    final Map<String, dynamic> result = {};

    result['currentServerId'] = _prefs.getString(_currentServerIdKey);
    result['servers'] = await getServerConfigs();

    return result;
  }

  Future<void> clear() async {
    await init();
    await _prefs.clear();
  }
}
