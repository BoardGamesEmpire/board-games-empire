import 'dart:convert';

import 'package:http/http.dart' as http;

import './api_exception.dart';

class BaseApi {
  String _baseUrl;

  BaseApi({required String baseUrl}) : _baseUrl = baseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  Uri buildUrl(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$_baseUrl$path');
  }

  String get baseUrl => _baseUrl;

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    final url = buildUrl(endpoint);

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(headers, token),
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

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(headers, token),
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

    try {
      final response = await http.put(
        url,
        headers: _buildHeaders(headers, token),
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

    try {
      final response = await http.delete(
        url,
        headers: _buildHeaders(headers, token),
        body: body != null ? (body is String ? body : jsonEncode(body)) : null,
      );

      return _processResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: ${e.toString()}');
    }
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
