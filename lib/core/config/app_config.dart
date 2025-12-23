class AppConfig {
  static const String appName = 'Messenger';
  static const String version = '1.0.0';

  // Set to true for local testing without server
  static const bool useLocalMode = true;

  static const String baseUrl = 'https://api.messenger.example.com';
  static const String websocketUrl = 'wss://ws.messenger.example.com';
  
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Duration messageAnimationDuration = Duration(milliseconds: 200);
  
  static const double messageMaxWidth = 0.7;
  static const double sidebarWidth = 320;
  static const double memberListWidth = 240;
  
  static const int maxMessageLength = 4000;
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
}
