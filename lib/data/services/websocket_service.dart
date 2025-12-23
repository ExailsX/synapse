import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'token_storage.dart';

class WebSocketService {
  final TokenStorage _tokenStorage;
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  
  final _messageController = StreamController<WebSocketMessage>.broadcast();
  final _connectionStateController = StreamController<ConnectionState>.broadcast();
  
  Stream<WebSocketMessage> get messageStream => _messageController.stream;
  Stream<ConnectionState> get connectionStateStream => _connectionStateController.stream;
  
  WebSocketService(this._tokenStorage);
  
  Future<void> connect() async {
    if (_channel != null) {
      return;
    }
    
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }
      
      final wsUrl = 'wss://ws.messenger.example.com?token=$token';
      
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['websocket'],
      );
      
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
      
      _connectionStateController.add(ConnectionState.connected);
      _reconnectAttempts = 0;
      
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _connectionStateController.add(ConnectionState.disconnected);
      _scheduleReconnect();
    }
  }
  
  void _onMessage(dynamic data) {
    try {
      final json = jsonDecode(data as String);
      final message = WebSocketMessage.fromJson(json);
      _messageController.add(message);
    } catch (e) {
      debugPrint('Error parsing WebSocket message: $e');
    }
  }
  
  void _onError(dynamic error) {
    debugPrint('WebSocket error: $error');
    _connectionStateController.add(ConnectionState.error);
    _scheduleReconnect();
  }
  
  void _onDone() {
    debugPrint('WebSocket connection closed');
    _connectionStateController.add(ConnectionState.disconnected);
    _channel = null;
    
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }
  
  void _scheduleReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      debugPrint('Max reconnection attempts reached');
      return;
    }
    
    _reconnectAttempts++;
    final delay = Duration(seconds: 2 * _reconnectAttempts);
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_shouldReconnect) {
        connect();
      }
    });
  }
  
  void sendMessage(String type, Map<String, dynamic> data) {
    if (_channel == null) {
      debugPrint('WebSocket not connected');
      return;
    }
    
    final message = {
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _channel!.sink.add(jsonEncode(message));
  }
  
  void sendTypingStatus(String chatId, bool isTyping) {
    sendMessage('typing', {
      'chatId': chatId,
      'isTyping': isTyping,
    });
  }
  
  void sendMessageStatus(String chatId, String messageId, String status) {
    sendMessage('message_status', {
      'chatId': chatId,
      'messageId': messageId,
      'status': status,
    });
  }
  
  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
  
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionStateController.close();
  }
}

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  WebSocketMessage({
    required this.type,
    required this.data,
    required this.timestamp,
  });
  
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  bool get isNewMessage => type == 'new_message';
  bool get isTyping => type == 'typing';
  bool get isUserStatus => type == 'user_status';
  bool get isMessageStatus => type == 'message_status';
}
