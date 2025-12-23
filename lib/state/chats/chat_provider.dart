import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/websocket_service.dart';
import '../auth/auth_provider.dart';

final chatsProvider = StateNotifierProvider<ChatsNotifier, ChatsState>((ref) {
  return ChatsNotifier(ref);
});

final currentChatProvider = Provider<Chat?>((ref) {
  final state = ref.watch(chatsProvider);
  return state.currentChatId != null 
      ? state.chats.firstWhereOrNull((c) => c.id == state.currentChatId)
      : null;
});

final chatMessagesProvider = Provider.family<List<Message>, String>((ref, chatId) {
  final state = ref.watch(chatsProvider);
  return state.messages[chatId] ?? [];
});

final typingUsersProvider = Provider.family<List<User>, String>((ref, chatId) {
  final state = ref.watch(chatsProvider);
  return state.typingUsers[chatId] ?? [];
});

class ChatsNotifier extends StateNotifier<ChatsState> {
  final Ref _ref;
  
  ChatsNotifier(this._ref) : super(const ChatsState()) {
    _init();
  }
  
  Future<void> _init() async {
    await loadChats();
    _subscribeToWebSocket();
  }
  
  void _subscribeToWebSocket() {
    final websocketService = _ref.read(websocketServiceProvider);
    
    websocketService.messageStream.listen((message) {
      if (message.isNewMessage) {
        _handleNewMessage(message.data);
      } else if (message.isTyping) {
        _handleTypingEvent(message.data);
      }
    });
  }
  
  Future<void> loadChats() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      final chats = await apiService.getChats();
      
      state = state.copyWith(
        chats: chats,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> loadMessages(String chatId, {int limit = 50}) async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      final messages = await apiService.getMessages(
        chatId: chatId,
        limit: limit,
      );
      
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[chatId] = messages;
      
      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
    }
  }
  
  Future<void> sendMessage({
    required String chatId,
    required String content,
    String? replyToMessageId,
  }) async {
    if (content.trim().isEmpty) return;
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      final message = await apiService.sendMessage(
        chatId: chatId,
        content: content.trim(),
        replyToMessageId: replyToMessageId,
      );
      
      _addMessageToChat(chatId, message);
      
      final websocketService = _ref.read(websocketServiceProvider);
      websocketService.sendMessageStatus(chatId, message.id, 'sent');
      
    } catch (e) {
    }
  }
  
  Future<void> markMessagesAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    if (messageIds.isEmpty) return;
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      await apiService.markMessagesAsRead(
        chatId: chatId,
        messageIds: messageIds,
      );
      
      _updateMessageStatus(chatId, messageIds, MessageStatus.read);
      
    } catch (e) {
    }
  }
  
  void setCurrentChat(String? chatId) {
    state = state.copyWith(currentChatId: chatId);
    
    if (chatId != null) {
      final chat = state.chats.firstWhereOrNull((c) => c.id == chatId);
      if (chat != null && chat.unreadCount > 0) {
        _markChatAsRead(chatId);
      }
    }
  }
  
  void _markChatAsRead(String chatId) {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(unreadCount: 0);
      }
      return chat;
    }).toList();
    
    state = state.copyWith(chats: updatedChats);
  }
  
  void _addMessageToChat(String chatId, Message message) {
    final updatedMessages = Map<String, List<Message>>.from(state.messages);
    final chatMessages = updatedMessages[chatId] ?? [];
    
    chatMessages.add(message);
    updatedMessages[chatId] = chatMessages;
    
    state = state.copyWith(messages: updatedMessages);
    
    _updateLastMessage(chatId, message);
  }
  
  void _updateLastMessage(String chatId, Message message) {
    final updatedChats = state.chats.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(
          lastMessage: message,
          lastActivity: message.createdAt,
        );
      }
      return chat;
    }).toList();
    
    state = state.copyWith(chats: updatedChats);
  }
  
  void _updateMessageStatus(String chatId, List<String> messageIds, MessageStatus status) {
    final updatedMessages = Map<String, List<Message>>.from(state.messages);
    final chatMessages = updatedMessages[chatId] ?? [];
    
    updatedMessages[chatId] = chatMessages.map((message) {
      if (messageIds.contains(message.id)) {
        return message.copyWith(status: status);
      }
      return message;
    }).toList();
    
    state = state.copyWith(messages: updatedMessages);
  }
  
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      final message = Message.fromJson(data['message'] as Map<String, dynamic>);
      final chatId = data['chatId'] as String;
      
      if (!message.isMine) {
        _addMessageToChat(chatId, message);
      }
    } catch (e) {
      debugPrint('Error handling new message: $e');
    }
  }
  
  void _handleTypingEvent(Map<String, dynamic> data) {
    try {
      final chatId = data['chatId'] as String;
      final userId = data['userId'] as String;
      final isTyping = data['isTyping'] as bool;
      
      final updatedTypingUsers = Map<String, List<User>>.from(state.typingUsers);
      final chatTypingUsers = updatedTypingUsers[chatId] ?? [];
      
      if (isTyping) {
        final user = state.chats
            .expand((chat) => chat.participants)
            .firstWhereOrNull((user) => user.id == userId);
            
        if (user != null && !chatTypingUsers.any((u) => u.id == userId)) {
          chatTypingUsers.add(user);
          updatedTypingUsers[chatId] = chatTypingUsers;
          state = state.copyWith(typingUsers: updatedTypingUsers);
        }
      } else {
        chatTypingUsers.removeWhere((user) => user.id == userId);
        updatedTypingUsers[chatId] = chatTypingUsers;
        state = state.copyWith(typingUsers: updatedTypingUsers);
      }
    } catch (e) {
      debugPrint('Error handling typing event: $e');
    }
  }
  
  void sendTypingStatus(String chatId, bool isTyping) {
    final websocketService = _ref.read(websocketServiceProvider);
    websocketService.sendTypingStatus(chatId, isTyping);
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

class ChatsState {
  final List<Chat> chats;
  final String? currentChatId;
  final Map<String, List<Message>> messages;
  final Map<String, List<User>> typingUsers;
  final bool isLoading;
  final String? error;
  
  const ChatsState({
    this.chats = const [],
    this.currentChatId,
    this.messages = const {},
    this.typingUsers = const {},
    this.isLoading = false,
    this.error,
  });
  
  ChatsState copyWith({
    List<Chat>? chats,
    String? currentChatId,
    Map<String, List<Message>>? messages,
    Map<String, List<User>>? typingUsers,
    bool? isLoading,
    String? error,
  }) {
    return ChatsState(
      chats: chats ?? this.chats,
      currentChatId: currentChatId ?? this.currentChatId,
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  throw UnimplementedError('Must be overridden in bootstrap');
});
