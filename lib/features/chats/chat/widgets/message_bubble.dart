import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/chat_model.dart';

class MessageBubble extends ConsumerWidget {
  final Message message;
  final bool showTime;
  final bool isConsecutive;
  
  const MessageBubble({
    super.key,
    required this.message,
    required this.showTime,
    required this.isConsecutive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMine = message.isMine;
    
    return Container(
      padding: EdgeInsets.only(
        left: isMine ? 64 : 16,
        right: isMine ? 16 : 64,
        top: isConsecutive ? 2 : 8,
        bottom: showTime ? 8 : 2,
      ),
      child: Column(
        crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMine && !isConsecutive)
                _buildAvatar(theme),
              if (!isMine && !isConsecutive)
                const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMine
                            ? theme.primaryColor
                            : theme.cardTheme.color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMine ? 18 : (isConsecutive ? 4 : 18)),
                          topRight: Radius.circular(isMine ? (isConsecutive ? 4 : 18) : 18),
                          bottomLeft: const Radius.circular(18),
                          bottomRight: const Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.isReply)
                            _buildReplyPreview(context),
                          Text(
                            message.content,
                            style: TextStyle(
                              fontSize: 15,
                              color: isMine
                                  ? Colors.white
                                  : theme.textTheme.bodyLarge?.color,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isMine && !isConsecutive)
                const SizedBox(width: 8),
              if (isMine && !isConsecutive)
                _buildAvatar(theme),
            ],
          ),
          if (showTime)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 48, right: 48),
              child: Text(
                DateFormat('h:mm a').format(message.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.person,
        color: theme.primaryColor,
        size: 16,
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: theme.dividerTheme.color?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Replying to message',
            style: TextStyle(
              fontSize: 12,
              color: theme.primaryColor,
              fontWeight: FontWeight.w600,
              
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Original message content preview...',
            style: TextStyle(
              fontSize: 13,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
