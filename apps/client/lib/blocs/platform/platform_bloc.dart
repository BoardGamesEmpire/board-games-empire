import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;
import 'package:web/web.dart' as web;

import '../../../config/environment_config.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  PlatformBloc() : super(PlatformState.initial()) {
    on<PlatformInitialized>(_onInitialized);
    on<PlatformWebBaseUrlRequested>(_onWebBaseUrlRequested);
  }

  void _onInitialized(PlatformInitialized event, Emitter<PlatformState> emit) {
    final isWeb = kIsWeb;
    final isMobile = _checkIsMobile();
    final isDesktop = _checkIsDesktop();

    final platformName = _determinePlatformName();

    emit(
      state.copyWith(
        isWeb: isWeb,
        isMobile: isMobile,
        isDesktop: isDesktop,
        platformName: platformName,
        isInitialized: true,
      ),
    );
  }

  void _onWebBaseUrlRequested(
    PlatformWebBaseUrlRequested event,
    Emitter<PlatformState> emit,
  ) {
    if (!state.isWeb) {
      emit(state.copyWith(webBaseUrl: ''));
      return;
    }

    try {
      final location = web.window.location;

      final webBaseUrl = EnvironmentConfig.getWebApiBaseUrl(
        protocol: location.protocol,
        hostname: location.hostname,
        specifiedPort: location.port,
      );

      emit(
        state.copyWith(
          webBaseUrl: webBaseUrl,
          webLocationDetails: {
            'href': location.href,
            'origin': location.origin,
            'protocol': location.protocol,
            'host': location.host,
            'hostname': location.hostname,
            'port': location.port,
            'pathname': location.pathname,
            'search': location.search,
            'hash': location.hash,
          },
        ),
      );
    } catch (e) {
      emit(state.copyWith(webBaseUrl: '/api/v1', webError: e.toString()));
    }
  }

  bool _checkIsMobile() {
    if (kIsWeb) return false;

    try {
      return Platform.isIOS || Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  bool _checkIsDesktop() {
    if (kIsWeb) return false;

    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  String _determinePlatformName() {
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
}
