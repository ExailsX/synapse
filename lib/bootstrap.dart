import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'core/config/app_config.dart';
import 'data/services/token_storage.dart';
import 'data/services/api_service.dart';
import 'data/services/websocket_service.dart';
import 'state/auth/auth_provider.dart';
import 'state/chats/chat_provider.dart';

Future<void> bootstrap() async {
  final stopwatch = Stopwatch()..start();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  
  final tokenStorage = TokenStorage(prefs);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
  
  dio.interceptors.addAll([
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) => debugPrint('[DIO] $log'),
    ),
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await tokenStorage.clear();
        }
        handler.next(error);
      },
    ),
  ]);
  
  final apiService = ApiService(dio);
  
  final websocketService = WebSocketService(tokenStorage);
  
  await tokenStorage.init();
  
  final container = ProviderContainer(
    overrides: [
      tokenStorageProvider.overrideWithValue(tokenStorage),
      apiServiceProvider.overrideWithValue(apiService),
      websocketServiceProvider.overrideWithValue(websocketService),
    ],
  );
  
  stopwatch.stop();
  debugPrint('Bootstrap completed in ${stopwatch.elapsedMilliseconds}ms');
}
