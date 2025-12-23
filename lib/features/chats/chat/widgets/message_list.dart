import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/chat_model.dart';
import 'message_bubble.dart';

class MessageList extends ConsumerStatefulWidget {
  final String chatId;
  final List<Message> messages;
  
  const MessageList({
    super.key,
    required this.chatId,
    required this.messages,
  });

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Start a conversation!'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final previousMessage = index > 0 ? widget.messages[index - 1] : null;
        final nextMessage = index < widget.messages.length - 1 
            ? widget.messages[index + 1] 
            : null;
            
        final showDate = _shouldShowDate(message, previousMessage);
        final showTime = _shouldShowTime(message, nextMessage);
        
        return Column(
          children: [
            if (showDate)
              _DateDivider(date: message.createdAt),
            MessageBubble(
              message: message,
              showTime: showTime,
              isConsecutive: _isConsecutive(message, previousMessage),
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowDate(Message current, Message? previous) {
    if (previous == null) return true;
    
    final currentDate = DateTime(
      current.createdAt.year,
      current.createdAt.month,
      current.createdAt.day,
    );
    
    final previousDate = DateTime(
      previous.createdAt.year,
      previous.createdAt.month,
      previous.createdAt.day,
    );
    
    return currentDate != previousDate;
  }

  bool _shouldShowTime(Message current, Message? next) {
    if (next == null) return true;
    if (current.senderId != next.senderId) return true;
    
    final difference = next.createdAt.difference(current.createdAt);
    return difference.inMinutes > 5;
  }

  bool _isConsecutive(Message current, Message? previous) {
    if (previous == null) return false;
    if (current.senderId != previous.senderId) return false;
    
    final difference = current.createdAt.difference(previous.createdAt);
    return difference.inMinutes < 5;
  }
}

class _DateDivider extends StatelessWidget {
  final DateTime date;
  
  const _DateDivider({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);
    
    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMMM d, y').format(date);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1, height: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                
              ),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 1, height: 1),
          ),
        ],
      ),
    );
  }
}
