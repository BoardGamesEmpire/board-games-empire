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
  static const String serverEdit = '/server-config/:serverId/edit';

  // Feature routes
  static const String gameGateways = '/games/gateways';
  static const String gameCollection = '/games/collection';
  static const String gameSearch = '/games/search';
  static const String gameDetails = '/games/:gameId';

  static const String chat = '/chat';
}

class AppRouteNames {
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';

  static const String home = 'home';

  static const String sessionManagement = 'session-management';
  static const String themeSettings = 'theme-settings';
  static const String languageSettings = 'language-settings';
  static const String notificationSettings = 'notification-settings';
  static const String privacySettings = 'privacy-settings';
  static const String accountSettings = 'account-settings';
  static const String websocketSettings = 'websocket-settings';
  static const String connectionSettings = 'connection-settings';

  static const String account = 'account';

  static const String serverConfig = 'server-config';
  static const String serverSelection = 'server-selection';
  static const String serverEdit = 'server-edit';

  static const String gameCollection = 'game-collection';
  static const String gameDetails = 'game-details';
  static const String gameSearch = 'game-search';

  static const String gameGateways = 'game-gateways';

  static const String chat = 'chat';
}
