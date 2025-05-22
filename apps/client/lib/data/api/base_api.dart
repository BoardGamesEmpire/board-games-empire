import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:board_games_empire/repositories/auth/auth_repository.dart';

import 'api_exception.dart';

class BaseApi {
  final AuthRepository? _authRepository;

  String _baseUrl;

  // TODO: temporary for local development
  final String _serverUrl = 'http://localhost:33333';

  BaseApi({required String baseUrl, AuthRepository? authRepo})
    : _baseUrl = baseUrl,
      _authRepository = authRepo;

  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  Uri buildUrl(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$_serverUrl$_baseUrl$path');
  }

  String get baseUrl => _baseUrl;

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    final url = buildUrl(endpoint);
    final accessToken = _getAccessToken(token);

    if (kDebugMode) {
      print('Get URL: $url');
    }

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(headers, accessToken),
      );

      return _processResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    required dynamic body,
    Map<String, String>? headers,
    String? token,
  }) async {
    final url = buildUrl(endpoint);
    final accessToken = _getAccessToken(token);

    if (kDebugMode) {
      print('Post URL: $url');
    }

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(headers, accessToken),
        body: body is String ? body : jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<dynamic> put(
    String endpoint, {
    required dynamic body,
    Map<String, String>? headers,
    String? token,
  }) async {
    final url = buildUrl(endpoint);
    final accessToken = _getAccessToken(token);

    if (kDebugMode) {
      print('Put URL: $url');
    }

    try {
      final response = await http.put(
        url,
        headers: _buildHeaders(headers, accessToken),
        body: body is String ? body : jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    required dynamic body,
    Map<String, String>? headers,
    String? token,
  }) async {
    final url = buildUrl(endpoint);
    final accessToken = _getAccessToken(token);

    if (kDebugMode) {
      print('Patch URL: $url');
    }

    try {
      final response = await http.patch(
        url,
        headers: _buildHeaders(headers, accessToken),
        body: body is String ? body : jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
    dynamic body,
  }) async {
    final url = buildUrl(endpoint);
    final accessToken = _getAccessToken(token);

    if (kDebugMode) {
      print('Delete URL: $url');
    }

    try {
      final response = await http.delete(
        url,
        headers: _buildHeaders(headers, accessToken),
        body: body != null ? (body is String ? body : jsonEncode(body)) : null,
      );

      return _processResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
  }

  String? _getAccessToken(String? token) {
    return token ?? _authRepository?.accessToken;
  }

  Map<String, String> _buildHeaders(
    Map<String, String>? headers,
    String? token,
  ) {
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }

    return {...defaultHeaders, ...?headers};
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      String message;
      try {
        final body = jsonDecode(response.body);
        message = body['message'] ?? 'Unknown error occurred';
      } catch (e) {
        message = response.body;
      }

      throw ApiException(message: message, statusCode: response.statusCode);
    }
  }
}
