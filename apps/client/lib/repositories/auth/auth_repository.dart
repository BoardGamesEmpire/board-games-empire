import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/api/auth_api.dart';
import '../../data/local/secure_storage.dart';
import '../../data/local/user_preferences.dart';
import '../../models/auth/auth.dart';
import '../../models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  final AuthApi _authApi;
  final SecureStorage _secureStorage;
  final UserPreferences _userPreferences;

  final _controller = BehaviorSubject<AuthStatus>.seeded(AuthStatus.unknown);
  final _userController = BehaviorSubject<User?>();

  String? _currentServerId;
  AuthTokens? _tokens;
  User? _currentUser;
  String? _lastError;

  String? get lastError => _lastError;

  AuthRepository({
    required AuthApi authApi,
    required SecureStorage secureStorage,
    required UserPreferences userPreferences,
  }) : _authApi = authApi,
       _secureStorage = secureStorage,
       _userPreferences = userPreferences {
    _init();
  }

  Future<void> _init() async {
    _currentServerId = await _userPreferences.getCurrentServerId();
    if (_currentServerId != null) {
      await _loadTokensFromStorage();
    } else {
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  Future<void> _loadTokensFromStorage() async {
    try {
      if (_currentServerId == null) return;

      final serverPrefix = 'server_${_currentServerId}_';

      final accessToken = await _secureStorage.read(
        '${serverPrefix}access_token',
      );
      final refreshToken = await _secureStorage.read(
        '${serverPrefix}refresh_token',
      );
      final userJson = await _userPreferences.getUserData(_currentServerId!);

      if (accessToken != null && refreshToken != null && userJson != null) {
        _tokens = AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        _currentUser = User.fromJson(userJson);
        _userController.add(_currentUser);

        _controller.add(AuthStatus.authenticated);

        _refreshTokenSilently();
      } else {
        _controller.add(AuthStatus.unauthenticated);
      }
    } catch (e) {
      await _clearAuthData();
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  Future<void> _saveTokensToStorage(AuthTokens tokens, User user) async {
    if (_currentServerId == null) return;

    final serverPrefix = 'server_${_currentServerId}_';

    await _secureStorage.write(
      '${serverPrefix}access_token',
      tokens.accessToken,
    );
    await _secureStorage.write(
      '${serverPrefix}refresh_token',
      tokens.refreshToken,
    );
    await _userPreferences.saveUserData(_currentServerId!, user);

    _tokens = tokens;
    _currentUser = user;
    _userController.add(_currentUser);
  }

  Future<void> _clearAuthData() async {
    if (_currentServerId != null) {
      final serverPrefix = 'server_${_currentServerId}_';

      await _secureStorage.delete('${serverPrefix}access_token');
      await _secureStorage.delete('${serverPrefix}refresh_token');
      await _userPreferences.removeUserData(_currentServerId!);
    }

    _tokens = null;
    _currentUser = null;
    _userController.add(null);
  }

  Future<bool> _refreshTokenSilently() async {
    if (_tokens?.refreshToken == null) return false;

    try {
      final response = await _authApi.refreshToken(_tokens!.refreshToken);

      _tokens = AuthTokens(
        accessToken: response.accessToken,
        refreshToken: _tokens!.refreshToken,
      );

      await _secureStorage.write(
        'server_${_currentServerId}_access_token',
        _tokens!.accessToken,
      );

      return true;
    } catch (e) {
      _lastError = e.toString();
      await _clearAuthData();
      _controller.add(AuthStatus.unauthenticated);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    Map<String, dynamic>? deviceInfo,
    bool rememberMe = false,
  }) async {
    try {
      _lastError = null;
      final actualDeviceInfo = deviceInfo ?? await getDeviceInfo();

      final response = await _authApi.login(
        email: email,
        password: password,
        deviceInfo: actualDeviceInfo,
        rememberMe: rememberMe,
      );

      await _saveTokensToStorage(response.tokens, response.user);

      _controller.add(AuthStatus.authenticated);
      return true;
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      _lastError = null;
      final success = await _authApi.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      return success;
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  Future<void> logout({bool allSessions = false}) async {
    try {
      if (_tokens?.accessToken != null) {
        await _authApi.logout(
          accessToken: _tokens!.accessToken,
          allSessions: allSessions,
        );
      }
    } catch (e) {
      // Log error but continue with local logout
      debugPrint('Logout API error: ${e.toString()}');
    } finally {
      await _clearAuthData();
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  Future<List<UserSession>> getActiveSessions() async {
    if (_tokens?.accessToken == null) return [];

    try {
      return await _authApi.getActiveSessions(_tokens!.accessToken);
    } catch (e) {
      _lastError = e.toString();
      return [];
    }
  }

  Future<bool> logoutSession(String sessionId) async {
    if (_tokens?.accessToken == null) return false;

    try {
      final success = await _authApi.logoutSession(
        accessToken: _tokens!.accessToken,
        sessionId: sessionId,
      );

      return success;
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      return await _authApi.requestPasswordReset(email);
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      return await _authApi.resetPassword(token, newPassword);
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  Future<void> setCurrentServer(String serverId) async {
    if (_currentServerId != serverId) {
      await _clearAuthData();
      _currentServerId = serverId;
      await _userPreferences.setCurrentServerId(serverId);
      await _loadTokensFromStorage();

      _authApi.setBaseUrl(await _userPreferences.getServerUrl(serverId));
    }
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;
    final appName = packageInfo.appName;

    if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      return {
        'browser': webInfo.browserName.name,
        'platform': webInfo.platform,
        'userAgent': webInfo.userAgent,
        'appName': appName,
        'appVersion': appVersion,
      };
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'device': androidInfo.model,
        'os': 'Android ${androidInfo.version.release}',
        'manufacturer': androidInfo.manufacturer,
        'appName': appName,
        'appVersion': appVersion,
      };
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'device': iosInfo.model,
        'os': '${iosInfo.systemName} ${iosInfo.systemVersion}',
        'appName': appName,
        'appVersion': appVersion,
      };
    } else {
      // Handle desktop platforms
      return {
        'device': 'Desktop',
        'os': defaultTargetPlatform.toString(),
        'appName': appName,
        'appVersion': appVersion,
      };
    }
  }

  // Getters
  Stream<AuthStatus> get status => _controller.stream;
  Stream<User?> get user => _userController.stream;
  Future<User?> getCurrentUser() async => _currentUser;
  String? get accessToken => _tokens?.accessToken;
  String? get refreshToken => _tokens?.refreshToken;

  void dispose() {
    _controller.close();
    _userController.close();
  }
}
