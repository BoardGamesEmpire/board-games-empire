import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:web/web.dart' as web;
import '../config/environment_config.dart';

class PlatformService {
  static bool get isWeb => kIsWeb;

  static bool get isMobile {
    if (kIsWeb) return false;

    try {
      return Platform.isIOS || Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  static bool get isDesktop {
    if (kIsWeb) return false;
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  static String get platformName {
    if (kIsWeb) return 'Web';

    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isLinux) return 'Linux';
    } catch (e) {}

    return 'Unknown';
  }

  static String get webBaseUrl {
    if (!kIsWeb) return '';

    try {
      final location = web.window.location;

      print('Location Properties:');
      print('  href: ${location.href}');
      print('  origin: ${location.origin}');
      print('  protocol: ${location.protocol}');
      print('  host: ${location.host}');
      print('  hostname: ${location.hostname}');
      print('  port: ${location.port}');
      print('  pathname: ${location.pathname}');
      print('  search: ${location.search}');
      print('  hash: ${location.hash}');

      return EnvironmentConfig.getWebApiBaseUrl(
        protocol: location.protocol,
        hostname: location.hostname,
        specifiedPort: location.port,
      );
    } catch (e) {
      print('Error getting web base URL: $e');
      return '/api/v1';
    }
  }
}
