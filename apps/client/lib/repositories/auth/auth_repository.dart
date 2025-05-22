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

    if (kDebugMode) {
      print('INIT: Current server ID: $_currentServerId');
    }

    if (_currentServerId != null) {
      await _loadTokensFromStorage();
    } else {
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  Future<void> switchServer(String serverId) async {
    final currentServerId = await _userPreferences.getCurrentServerId();

    if (currentServerId != serverId) {
      await _clearAuthData();

      _currentServerId = serverId;
      await _userPreferences.setCurrentServerId(serverId);

      final serverUrl = await _userPreferences.getServerUrl(serverId);
      _authApi.setBaseUrl(serverUrl!);

      await _loadTokensFromStorage();
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
        if (kDebugMode) {
          print('No tokens found in storage for server: $serverPrefix');
          print(userJson);
          print(accessToken);
          print(refreshToken);
        }
        _controller.add(AuthStatus.unauthenticated);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tokens from storage: ${e.toString()}');
      }

      await _clearAuthData();
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  Future<void> _saveTokensToStorage(AuthTokens tokens, User user) async {
    if (_currentServerId == null) return;

    final serverPrefix = 'server_${_currentServerId}_';

    if (kDebugMode) {
      print('Saving tokens for server: $serverPrefix');
    }

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

      _controller.add(AuthStatus.authenticated);

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

  // TODO: move to UserRepository
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

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _authApi.changePassword(
        accessToken: accessToken ?? '',
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return response;
    } catch (e) {
      _lastError = e.toString();
      return false;
    }
  }

  // TODO: move to UserRepository
  Future<User?> updateProfile({
    required String username,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final user = await _authApi.updateProfile(
        accessToken: accessToken ?? '',
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      // Update local user data
      if (user != null) {
        _currentUser = user;
        if (_currentServerId != null) {
          await _userPreferences.saveUserData(_currentServerId!, user);
        }
        _userController.add(user);
      }

      return user;
    } catch (e) {
      _lastError = e.toString();
      return null;
    }
  }

  // TODO: maybe this should be moved to a separate repository
  Future<void> setCurrentServer(String serverId) async {
    if (_currentServerId != serverId) {
      await switchServer(serverId);
      _controller.add(
        _tokens != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      );
    }
  }

  // TODO: Platform bloc should handle this
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
  String? get currentUserId => _currentUser?.id;
  bool get isAuthenticated => _controller.value == AuthStatus.authenticated;

  void dispose() {
    _controller.close();
    _userController.close();
  }
}
