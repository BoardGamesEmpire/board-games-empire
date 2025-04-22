import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/platform/platform_bloc.dart';

/// A provider class to access platform information throughout the app
/// Acts as a compatibility layer during refactoring from service to BLoC pattern
class PlatformProvider {
  static late final PlatformProvider _instance;

  late final PlatformBloc _platformBloc;

  PlatformProvider({required PlatformBloc platformBloc})
    : _platformBloc = platformBloc;

  /// Creates a PlatformProvider from the current BuildContext
  factory PlatformProvider.of(BuildContext context) {
    return PlatformProvider(
      platformBloc: BlocProvider.of<PlatformBloc>(context),
    );
  }

  /// Whether the app is running on the web
  static bool get isWeb => _currentPlatformState.isWeb;

  /// Whether the app is running on a mobile device (iOS or Android)
  static bool get isMobile => _currentPlatformState.isMobile;

  /// Whether the app is running on a desktop (Windows, macOS, Linux)
  static bool get isDesktop => _currentPlatformState.isDesktop;

  /// The name of the current platform
  static String get platformName => _currentPlatformState.platformName;

  /// The base URL for web API requests
  static String get webBaseUrl {
    final state = _currentPlatformState;
    if (!state.isWeb) return '';

    if (state.webBaseUrl.isEmpty) {
      // Trigger a request for web base URL if not available
      __platformBloc.add(const PlatformWebBaseUrlRequested());
      return '/api/v1';
    }

    return state.webBaseUrl;
  }

  /// Gets the current platform state from the bloc
  static PlatformState get _currentPlatformState {
    return __platformBloc.state;
  }

  /// Access to the internal PlatformBloc
  static PlatformBloc get __platformBloc => _instance._platformBloc;

  /// Initialize the singleton
  static void initialize(PlatformBloc platformBloc) {
    _instance = PlatformProvider(platformBloc: platformBloc);
  }
}
