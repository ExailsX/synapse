class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String home = '/home';
  static const String chat = '/chat/:chatId';
  static const String server = '/server/:serverId';
  static const String channel = '/server/:serverId/channel/:channelId';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String search = '/search';
  
  static String chatPath(String chatId) => '/chat/$chatId';
  static String serverPath(String serverId) => '/server/$serverId';
  static String channelPath(String serverId, String channelId) => '/server/$serverId/channel/$channelId';
}
