/// Defines named routes as constants to avoid string literals throughout the app
class AppRoutes {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';
  static const String sessionManagement = '/account/sessions';

  // Config routes
  static const String serverConfig = '/server-config';
  static const String serverSelection = '/server-selection';

  // Feature routes
  static const String gameCollection = '/games/collection';
  static const String gameSearch = '/games/search';
  static const String gameDetails = '/games/:id';
  static const String chat = '/chat';

  // Helper method to build game details path
  static String buildGameDetailsPath(String gameId) => '/games/$gameId';
}
