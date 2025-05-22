/// Defines named routes as constants to avoid string literals throughout the app
class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main app routes
  static const String home = '/home';

  // Settings routes
  static const String sessionManagement = '/account/sessions';
  static const String themeSettings = '/settings/theme';
  static const String languageSettings = '/settings/language';
  static const String notificationSettings = '/settings/notifications';
  static const String privacySettings = '/settings/privacy';
  static const String accountSettings = '/settings/account';
  static const String websocketSettings = '/settings/websocket';
  static const String connectionSettings = '/settings/connection';

  // Account routes
  static const String account = '/account';

  // Config routes
  static const String serverConfig = '/server-config';
  static const String serverSelection = '/server-selection';

  // Feature routes
  static const String gameGateways = '/games/gateways';
  static const String gameCollection = '/games/collection';
  static const String gameSearch = '/games/search';
  static const String gameDetails = '/games/:id';

  static const String chat = '/chat';

  static String buildGameDetailsPath(String gameId) => '/games/$gameId';
}
