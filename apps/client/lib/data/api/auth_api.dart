import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';

import '../../models/auth/auth.dart';
import '../../models/user.dart';
import './api_exception.dart';
import './base_api.dart';

class AuthLoginResponse {
  final AuthTokens tokens;
  final User user;

  AuthLoginResponse({required this.tokens, required this.user});
}

class AuthRefreshResponse {
  final String accessToken;

  AuthRefreshResponse({required this.accessToken});
}

class AuthApi extends BaseApi {
  AuthApi({required super.baseUrl});

  final apiPrefix = '/auth';

  Future<AuthLoginResponse> login({
    required String email,
    required String password,
    Map<String, dynamic>? deviceInfo,
    bool rememberMe = false,
  }) async {
    try {
      final response = await http.post(
        buildUrl('$apiPrefix/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'deviceInfo': deviceInfo,
          'rememberMe': rememberMe,
        }),
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final data = jsonDecode(response.body);
        final tokens = AuthTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        final user = User.fromJson(data['user']);

        return AuthLoginResponse(tokens: tokens, user: user);
      } else {
        final error =
            response.statusCode == HttpStatusCode.unauthorized
                ? 'Invalid email or password'
                : 'Login failed: ${response.body}';
        throw ApiException(message: error, statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
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
      final response = await http.post(
        buildUrl('$apiPrefix/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      if (response.statusCode == HttpStatusCode.created) {
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        throw ApiException(
          message: responseData['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<bool> logout({
    required String accessToken,
    bool allSessions = false,
    String? sessionId,
  }) async {
    try {
      final response = await http.post(
        buildUrl('$apiPrefix/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'sessionId': allSessions ? null : sessionId,
          'allSessions': allSessions,
        }),
      );

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      throw ApiException(message: 'Logout failed: ${e.toString()}');
    }
  }

  Future<AuthRefreshResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        buildUrl('$apiPrefix/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final data = jsonDecode(response.body);
        return AuthRefreshResponse(accessToken: data['access_token']);
      } else {
        throw ApiException(
          message: 'Token refresh failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<List<UserSession>> getActiveSessions(String accessToken) async {
    try {
      final response = await http.get(
        buildUrl('$apiPrefix/sessions'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final List<dynamic> sessionsJson = jsonDecode(response.body);
        return sessionsJson
            .map((session) => UserSession.fromJson(session))
            .toList();
      } else {
        throw ApiException(
          message: 'Failed to fetch sessions',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<bool> logoutSession({
    required String accessToken,
    required String sessionId,
  }) async {
    try {
      final response = await http.post(
        buildUrl('$apiPrefix/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'sessionId': sessionId, 'allSessions': false}),
      );

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      throw ApiException(message: 'Failed to logout session: ${e.toString()}');
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        buildUrl('$apiPrefix/password-reset-request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      throw ApiException(
        message: 'Password reset request failed: ${e.toString()}',
      );
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        buildUrl('$apiPrefix/password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': newPassword}),
      );

      return response.statusCode == HttpStatusCode.ok;
    } catch (e) {
      throw ApiException(message: 'Password reset failed: ${e.toString()}');
    }
  }
}
