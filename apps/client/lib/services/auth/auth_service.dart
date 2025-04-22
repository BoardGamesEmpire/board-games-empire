import 'dart:convert';
import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http_status/http_status.dart';

import '../../services/platform_service.dart';
import '../../router/route_constants.dart';
import '../../models/auth/auth.dart';
import '../../models/user.dart';
import './logout_event.dart';

class AuthService extends ChangeNotifier {
  final apiPrefix = '/auth';

  String _baseUrl;

  final FlutterSecureStorage secureStorage;
  final StreamController<LogoutEvent> _logoutController =
      StreamController<LogoutEvent>.broadcast();
  Stream<LogoutEvent> get onLogout => _logoutController.stream;

  late SharedPreferences _prefs;
  AuthState _authState = AuthState();
  String? _currentSessionId;
  String? _currentServerId;

  String get baseUrl => _baseUrl;
  AuthState get authState => _authState;
  bool get isAuthenticated => _authState.isAuthenticated;
  User? get currentUser => _authState.user;
  String? get accessToken => _authState.tokens?.accessToken;
  String? get refreshToken => _authState.tokens?.refreshToken;
  String? get currentSessionId => _currentSessionId;

  AuthService({String baseUrl = ''})
    : _baseUrl = PlatformService.isWeb ? PlatformService.webBaseUrl : baseUrl,
      secureStorage = const FlutterSecureStorage() {
    _initService();
  }

  Future<void> _initService() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadTokensFromStorage();
  }

  void setBaseUrl(String url) {
    if (PlatformService.isWeb) return;

    _baseUrl = url;

    // TODO: Maybe just suspend auth state
    _clearAuthData();
    notifyListeners();
  }

  Future<void> _loadTokensFromStorage() async {
    try {
      _currentServerId = _prefs.getString('current_server_id');

      if (_currentServerId != null) {
        final serverPrefix = 'server_${_currentServerId}_';

        final accessToken = await secureStorage.read(
          key: '${serverPrefix}access_token',
        );
        final refreshToken = await secureStorage.read(
          key: '${serverPrefix}refresh_token',
        );
        final userJson = _prefs.getString('${serverPrefix}user_data');
        final sessionId = _prefs.getString('${serverPrefix}current_session_id');

        if (accessToken != null && refreshToken != null && userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          final tokens = AuthTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );

          _authState = _authState.copyWith(
            user: user,
            tokens: tokens,
            isAuthenticated: true,
          );

          _currentSessionId = sessionId;

          _refreshTokenSilently();
        }
      }
    } catch (e) {
      await _clearAuthData();
    }

    notifyListeners();
  }

  void setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  Future<void> _saveTokensToStorage(
    AuthTokens tokens,
    User user,
    String? sessionId,
  ) async {
    if (_currentServerId == null) {
      return;
    }

    final serverPrefix = 'server_${_currentServerId}_';

    await secureStorage.write(
      key: '${serverPrefix}access_token',
      value: tokens.accessToken,
    );
    await secureStorage.write(
      key: '${serverPrefix}refresh_token',
      value: tokens.refreshToken,
    );
    await _prefs.setString(
      '${serverPrefix}user_data',
      jsonEncode(user.toJson()),
    );

    if (sessionId != null) {
      await _prefs.setString('${serverPrefix}current_session_id', sessionId);
      _currentSessionId = sessionId;
    }
  }

  Future<void> _clearAuthData() async {
    if (_currentServerId != null) {
      final serverPrefix = 'server_${_currentServerId}_';

      await secureStorage.delete(key: '${serverPrefix}access_token');
      await secureStorage.delete(key: '${serverPrefix}refresh_token');
      await _prefs.remove('${serverPrefix}user_data');
      await _prefs.remove('${serverPrefix}current_session_id');
    }

    _currentSessionId = null;
    _authState = _authState.clearAuth();
  }

  String? _extractSessionId(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      return payload['sid'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
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
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      final macInfo = await deviceInfo.macOsInfo;
      return {
        'device': macInfo.model,
        'os': '${macInfo.arch} ${macInfo.osRelease}',
        'appName': appName,
        'appVersion': appVersion,
      };
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      return {
        'device': windowsInfo.computerName,
        'os': '${windowsInfo.releaseId} ${windowsInfo.buildNumber}',
        'appName': appName,
        'appVersion': appVersion,
      };
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      return {
        'device': linuxInfo.name,
        'os': '${linuxInfo.version} ${linuxInfo.prettyName}',
        'appName': appName,
        'appVersion': appVersion,
      };
    }

    return {
      'device': 'Unknown',
      'os': 'Unknown',
      'appName': appName,
      'appVersion': appVersion,
    };
  }

  Future<bool> login(String email, String password) async {
    _authState = _authState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final deviceInfo = await _getDeviceInfo();

      final response = await http.post(
        _buildUrl(AppRoutes.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'deviceInfo': deviceInfo,
        }),
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final data = jsonDecode(response.body);
        final tokens = AuthTokens.fromJson(data);
        final user = User.fromJson(data['user']);

        // Extract session ID from JWT
        final sessionId = _extractSessionId(tokens.accessToken);

        // Save tokens and user data
        await _saveTokensToStorage(tokens, user, sessionId);

        _authState = _authState.copyWith(
          user: user,
          tokens: tokens,
          isAuthenticated: true,
          isLoading: false,
        );

        notifyListeners();
        return true;
      } else {
        final error =
            response.statusCode == HttpStatusCode.unauthorized
                ? 'Invalid email or password'
                : 'Login failed. Please try again.';

        _authState = _authState.copyWith(isLoading: false, error: error);

        notifyListeners();
        return false;
      }
    } catch (e) {
      print(e.toString());
      _authState = _authState.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );

      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    _authState = _authState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final response = await http.post(
        _buildUrl('/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      _authState = _authState.copyWith(isLoading: false);

      if (response.statusCode == HttpStatusCode.created) {
        // Registration successful, but we don't auto-login
        notifyListeners();
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        _authState = _authState.copyWith(
          error: responseData['message'] ?? 'Registration failed',
        );

        notifyListeners();
        return false;
      }
    } catch (e) {
      _authState = _authState.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );

      notifyListeners();
      return false;
    }
  }

  Future<void> logout({bool allSessions = false}) async {
    if (!isAuthenticated || accessToken == null) return;

    try {
      await http.post(
        _buildUrl('/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'sessionId': allSessions ? null : _currentSessionId,
          'allSessions': allSessions,
        }),
      );
    } catch (e) {
      // TODO: proper logging

      if (kDebugMode) {
        print('Logout API error: ${e.toString()}');
      }
    } finally {
      await _clearAuthData();

      _logoutController.add(LogoutEvent(allSessions: allSessions));

      notifyListeners();
    }
  }

  _buildUrl(String endpoint) {
    final uri = Uri.parse('$baseUrl$apiPrefix$endpoint').toString();

    print(uri);

    return Uri.parse(uri);
  }

  Future<bool> _refreshTokenSilently() async {
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        _buildUrl('/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final data = jsonDecode(response.body);

        final newTokens = AuthTokens(
          accessToken: data['access_token'],
          refreshToken: refreshToken!,
        );

        await secureStorage.write(
          key: 'access_token',
          value: newTokens.accessToken,
        );

        _authState = _authState.copyWith(tokens: newTokens);
        notifyListeners();
        return true;
      } else {
        await _clearAuthData();
        notifyListeners();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<UserSession>> getActiveSessions() async {
    if (!isAuthenticated || accessToken == null) return [];

    try {
      final response = await http.get(
        _buildUrl('/sessions'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final List<dynamic> sessionsJson = jsonDecode(response.body);
        return sessionsJson
            .map(
              (session) => UserSession.fromJson(
                session,
                isCurrentSession: session['id'] == _currentSessionId,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error fetching sessions: ${e.toString()}');
    }

    return [];
  }

  Future<bool> logoutSession(String sessionId) async {
    if (!isAuthenticated || accessToken == null) return false;

    try {
      final response = await http.post(
        _buildUrl('/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'sessionId': sessionId, 'allSessions': false}),
      );

      // If we logged out our current session, clear auth data
      if (response.statusCode == HttpStatusCode.ok &&
          sessionId == _currentSessionId) {
        await _clearAuthData();
        notifyListeners();
      }

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      print('Error logging out session: ${e.toString()}');
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        _buildUrl('/password-reset-request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        _buildUrl('/password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': newPassword}),
      );

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      return false;
    }
  }

  Future<void> setCurrentServer(String serverId) async {
    if (_currentServerId != serverId) {
      await _clearAuthData();
      _currentServerId = serverId;
      await _prefs.setString('current_server_id', serverId);
      await _loadTokensFromStorage();
    }
  }

  @override
  void dispose() {
    _logoutController.close();
    super.dispose();
  }
}
