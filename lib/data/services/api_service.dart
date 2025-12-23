import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as json;
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../models/server_model.dart';
import '../../core/config/app_config.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> _loadLocalCredentials() async {
    if (!AppConfig.useLocalMode) return {};

    try {
      final jsonString = await rootBundle.loadString('assets/local_credentials.json');
      return json.jsonDecode(jsonString);
    } catch (e) {
      throw Exception('Failed to load local credentials: $e');
    }
  }
  
  Future<LoginResponse> login({
    required String identifier,
    required String password,
  }) async {
    if (AppConfig.useLocalMode) {
      final credentials = await _loadLocalCredentials();
      if (identifier == credentials['login'] && password == credentials['password']) {
        return LoginResponse(
          accessToken: credentials['tokens']['accessToken'],
          refreshToken: credentials['tokens']['refreshToken'],
          user: User.fromJson(credentials['user']),
        );
      } else {
        throw Exception('Invalid credentials');
      }
    }

    final response = await _dio.post('/auth/login', data: {
      'identifier': identifier,
      'password': password,
    });

    return LoginResponse.fromJson(response.data);
  }
  
  Future<RegisterResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    
    return RegisterResponse.fromJson(response.data);
  }
  
  Future<User> getCurrentUser() async {
    final response = await _dio.get('/users/me');
    return User.fromJson(response.data);
  }
  
  Future<List<Chat>> getChats() async {
    final response = await _dio.get('/chats');
    return (response.data as List)
        .map((json) => Chat.fromJson(json))
        .toList();
  }
  
  Future<List<Message>> getMessages({
    required String chatId,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    final response = await _dio.get('/chats/$chatId/messages', queryParameters: {
      'limit': limit,
      if (beforeMessageId != null) 'before': beforeMessageId,
    });
    
    return (response.data as List)
        .map((json) => Message.fromJson(json))
        .toList();
  }
  
  Future<Message> sendMessage({
    required String chatId,
    required String content,
    String? replyToMessageId,
  }) async {
    final response = await _dio.post('/chats/$chatId/messages', data: {
      'content': content,
      if (replyToMessageId != null) 'replyTo': replyToMessageId,
    });
    
    return Message.fromJson(response.data);
  }
  
  Future<List<Server>> getServers() async {
    final response = await _dio.get('/servers');
    return (response.data as List)
        .map((json) => Server.fromJson(json))
        .toList();
  }
  
  Future<List<Channel>> getChannels({
    required String serverId,
  }) async {
    final response = await _dio.get('/servers/$serverId/channels');
    return (response.data as List)
        .map((json) => Channel.fromJson(json))
        .toList();
  }
  
  Future<List<User>> searchUsers(String query) async {
    final response = await _dio.get('/users/search', queryParameters: {
      'q': query,
    });
    
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
  
  Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    await _dio.post('/chats/$chatId/read', data: {
      'messageIds': messageIds,
    });
  }
  
  Future<void> updateTypingStatus({
    required String chatId,
    required bool isTyping,
  }) async {
    await _dio.post('/chats/$chatId/typing', data: {
      'isTyping': isTyping,
    });
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final User user;
  
  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user']),
    );
  }
}

class RegisterResponse {
  final String message;
  final String userId;
  
  RegisterResponse({
    required this.message,
    required this.userId,
  });
  
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      userId: json['userId'],
    );
  }
}
