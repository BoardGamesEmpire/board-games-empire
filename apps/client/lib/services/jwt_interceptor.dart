import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth/auth.dart';
import './auth_service.dart';

class JwtHttpClient extends http.BaseClient {
  final http.Client _inner;
  final AuthService _authService;
  final String baseUrl;
  bool _isRefreshing = false;
  final List<Completer<http.StreamedResponse>> _pendingRequests = [];

  JwtHttpClient({
    required this.baseUrl,
    required AuthService authService,
    http.Client? inner,
  }) : _inner = inner ?? http.Client(),
       _authService = authService;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Add auth header if we have a token
    if (_authService.accessToken != null) {
      request.headers['Authorization'] = 'Bearer ${_authService.accessToken}';
    }

    // Send the request
    final response = await _inner.send(request);

    // If the response is 401 Unauthorized, try to refresh the token
    if (response.statusCode == 401 && _authService.refreshToken != null) {
      if (_isRefreshing) {
        // If already refreshing, queue this request to retry after refresh
        final completer = Completer<http.StreamedResponse>();
        _pendingRequests.add(completer);
        return completer.future;
      }

      try {
        _isRefreshing = true;
        // Try to refresh the token
        final refreshed = await _refreshToken();
        _isRefreshing = false;

        if (refreshed) {
          // Token refreshed, retry the original request
          final newRequest = await _copyRequest(request);
          newRequest.headers['Authorization'] =
              'Bearer ${_authService.accessToken}';

          // Process any pending requests
          for (final completer in _pendingRequests) {
            try {
              final retryResponse = await _inner.send(
                await _copyRequest(request),
              );
              completer.complete(retryResponse);
            } catch (e) {
              completer.completeError(e);
            }
          }
          _pendingRequests.clear();

          // Return the response for the current request
          return _inner.send(newRequest);
        } else {
          // Token refresh failed, reject all pending requests
          final error = Exception('Authentication failed');
          for (final completer in _pendingRequests) {
            completer.completeError(error);
          }
          _pendingRequests.clear();
        }
      } finally {
        _isRefreshing = false;
      }
    }

    return response;
  }

  // Helper to refresh the token
  Future<bool> _refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _authService.refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newTokens = AuthTokens(
          accessToken: data['access_token'],
          refreshToken: _authService.refreshToken!,
        );

        // Update auth service with new token
        await _authService.updateTokens(newTokens);
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }

    // If we reach here, refresh failed - logout user
    await _authService.logout();
    return false;
  }

  // Helper to create a copy of a request with a new auth header
  Future<http.BaseRequest> _copyRequest(http.BaseRequest request) async {
    final newRequest = http.Request(request.method, request.url);

    newRequest.headers.addAll(request.headers);
    newRequest.followRedirects = request.followRedirects;
    newRequest.maxRedirects = request.maxRedirects;
    newRequest.persistentConnection = request.persistentConnection;

    if (request is http.Request) {
      newRequest.body = request.body;
      newRequest.bodyFields = request.bodyFields;
      newRequest.encoding = request.encoding;
    }

    return newRequest;
  }
}

// Add update method to AuthService
extension AuthServiceExtension on AuthService {
  Future<void> updateTokens(AuthTokens tokens) async {
    await secureStorage.write(key: 'access_token', value: tokens.accessToken);
    final newAuthState = authState.copyWith(tokens: tokens);

    setAuthState(newAuthState);
    notifyListeners();
  }
}
