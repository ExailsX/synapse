import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../../core/navigation/routes.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/message_model.dart';
import '../../../state/chats/chat_provider.dart';
import 'widgets/message_list.dart';
import 'widgets/message_input.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String chatId;
  
  const ChatPage({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatsProvider.notifier).setCurrentChat(widget.chatId);
      ref.read(chatsProvider.notifier).loadMessages(widget.chatId);
    });
  }

  @override
  void dispose() {
    ref.read(chatsProvider.notifier).setCurrentChat(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatState = ref.watch(chatsProvider);
    final chat = chatState.chats.firstWhereOrNull((c) => c.id == widget.chatId);
    
    if (chat == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, chat),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              chatId: widget.chatId,
              messages: chatState.messages[widget.chatId] ?? [],
            ),
          ),
          MessageInput(
            onSendMessage: (content, {replyToMessageId}) {
              ref.read(chatsProvider.notifier).sendMessage(
                chatId: widget.chatId,
                content: content,
                replyToMessageId: replyToMessageId,
              );
            },
            onTyping: (isTyping) {
              ref.read(chatsProvider.notifier).sendTypingStatus(
                widget.chatId,
                isTyping,
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Chat chat) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go(AppRoutes.home);
        },
      ),
      title: InkWell(
        onTap: () {
          // TODO: Show chat info
        },
        child: Row(
          children: [
            _buildChatAvatar(context, chat),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.displayTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (chat.otherUser != null)
                    Text(
                      chat.otherUser!.statusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: chat.otherUser!.statusColor,
                        fontSize: 12,
                        
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call_outlined),
          onPressed: () {
            // TODO: Implement voice call
          },
        ),
        IconButton(
          icon: const Icon(Icons.videocam_outlined),
          onPressed: () {
            // TODO: Implement video call
          },
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          offset: const Offset(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Chat info'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 12),
                    Text('Search messages'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(Icons.volume_off_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Mute notifications'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'wallpaper',
                child: Row(
                  children: [
                    Icon(Icons.wallpaper_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Change wallpaper'),
                  ],
                ),
              ),
            ];
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildChatAvatar(BuildContext context, Chat chat) {
    final theme = Theme.of(context);
    
    if (chat.otherUser != null) {
      return Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                chat.otherUser!.initials,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (chat.isOnline)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF3BA55C),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.appBarTheme.backgroundColor!,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      );
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.group,
        color: theme.primaryColor,
        size: 20,
      ),
    );
  }
}
