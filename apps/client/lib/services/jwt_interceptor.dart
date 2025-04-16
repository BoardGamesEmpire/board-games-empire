import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/auth/auth.dart';
import './auth_service.dart';
import 'package:http_status/http_status.dart';

class JwtHttpClient extends http.BaseClient {
  final List<Completer<http.StreamedResponse>> _pendingRequests = [];
  late final AuthService _authService;
  final http.Client _inner;
  final String baseUrl;

  bool _isRefreshing = false;

  JwtHttpClient({
    required this.baseUrl,
    required AuthService authService,
    http.Client? inner,
  }) : _inner = inner ?? http.Client(),
       _authService = authService;

  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_authService.accessToken != null) {
      request.headers['Authorization'] = 'Bearer ${_authService.accessToken}';
    }

    final response = await _inner.send(request);

    if (response.statusCode == HttpStatusCode.unauthorized &&
        _authService.refreshToken != null) {
      if (_isRefreshing) {
        final completer = Completer<http.StreamedResponse>();

        _pendingRequests.add(completer);
        return completer.future;
      }

      try {
        _isRefreshing = true;
        final refreshed = await _refreshToken();
        _isRefreshing = false;

        if (refreshed) {
          final newRequest = await _copyRequest(request);
          newRequest.headers['Authorization'] =
              'Bearer ${_authService.accessToken}';

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

          return _inner.send(newRequest);
        } else {
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

  Future<bool> _refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _authService.refreshToken}),
      );

      if (response.statusCode == HttpStatusCode.ok) {
        final data = jsonDecode(response.body);
        final newTokens = AuthTokens(
          accessToken: data['access_token'],
          refreshToken: _authService.refreshToken!,
        );

        await _authService.updateTokens(newTokens);
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh failed: $e');
      }
    }

    await _authService.logout();
    return false;
  }

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

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final uri = _buildUri(url);
    return super.get(uri, headers: _addAuthHeaders(headers));
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(url);
    return super.post(
      uri,
      headers: _addAuthHeaders(headers),
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(url);
    return super.put(
      uri,
      headers: _addAuthHeaders(headers),
      body: body,
      encoding: encoding,
    );
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final uri = _buildUri(url);

    return super.delete(
      uri,
      headers: _addAuthHeaders(headers),
      body: body,
      encoding: encoding,
    );
  }

  _addAuthHeaders(Map<String, String>? headers) {
    if (_authService.accessToken != null) {
      headers ??= {};
      headers['Authorization'] = 'Bearer ${_authService.accessToken}';
    }

    return headers;
  }

  Uri _buildUri(Uri uri) {
    final path = uri.toString();
    final fullUrl =
        path.startsWith('http')
            ? path
            : '$baseUrl${path.startsWith('/') ? path : '/$path'}';
    return Uri.parse(fullUrl);
  }

  buildBearerHeader() {
    return _authService.accessToken != null
        ? {'Authorization': 'Bearer ${_authService.accessToken}'}
        : {};
  }
}

extension AuthServiceExtension on AuthService {
  Future<void> updateTokens(AuthTokens tokens) async {
    await secureStorage.write(key: 'access_token', value: tokens.accessToken);
    final newAuthState = authState.copyWith(tokens: tokens);

    setAuthState(newAuthState);
    notifyListeners();
  }

  String? get token => accessToken;
  String? get accessToken => authState.tokens?.accessToken;
  String? get refreshToken => authState.tokens?.refreshToken;
  bool get isAuthenticated => authState.isAuthenticated;
}
