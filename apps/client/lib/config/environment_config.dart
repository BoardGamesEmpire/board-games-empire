import 'package:flutter/foundation.dart';

class EnvironmentConfig {
  static const defaultApiPort = '33333';

  static String get apiPort =>
      const String.fromEnvironment('SERVER_PORT', defaultValue: defaultApiPort);

  static String getWebApiBaseUrl({
    required String protocol,
    required String hostname,
    String? specifiedPort,
  }) {
    final isLocalhost = hostname == 'localhost' || hostname == '127.0.0.1';
    final port = isLocalhost ? apiPort : specifiedPort ?? '';

    final portString = port.isNotEmpty ? ':$port' : '';
    return '$protocol//$hostname$portString/api/v1';
  }

  static bool get isUsingDefaultPort => apiPort == defaultApiPort;

  static Map<String, dynamic> get debugInfo => {
    'apiPort': apiPort,
    'isUsingDefaultPort': isUsingDefaultPort,
    'isDebugMode': kDebugMode,
  };
}
