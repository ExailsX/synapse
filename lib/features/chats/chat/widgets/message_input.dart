import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInput extends ConsumerStatefulWidget {
  final Function(String content, {String? replyToMessageId}) onSendMessage;
  final Function(bool isTyping) onTyping;
  
  const MessageInput({
    super.key,
    required this.onSendMessage,
    required this.onTyping,
  });

  @override
  ConsumerState<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !_isTyping) {
      _startTyping();
    }
  }

  void _startTyping() {
    _isTyping = true;
    widget.onTyping(true);
  }

  void _stopTyping() {
    if (_isTyping) {
      _isTyping = false;
      widget.onTyping(false);
    }
  }

  void _resetTypingTimer() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _stopTyping();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerTheme.color!,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: theme.primaryColor,
                size: 28,
              ),
              onPressed: () {
                _showAttachmentMenu(context);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.dividerTheme.color!,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onChanged: (value) {
                          if (value.trim().isNotEmpty && !_isTyping) {
                            _startTyping();
                          }
                          _resetTypingTimer();
                        },
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          hintStyle: TextStyle(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 16,
                            
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textTheme.bodyLarge?.color,
                          
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                        size: 24,
                      ),
                      onPressed: () {
                        // TODO: Show emoji picker
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mic_none_outlined,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                        size: 24,
                      ),
                      onPressed: () {
                        // TODO: Start voice recording
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    widget.onSendMessage(text);
    _controller.clear();
    _stopTyping();
    _typingTimer?.cancel();
  }

  void _showAttachmentMenu(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerTheme.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentButton(
                    icon: Icons.photo_outlined,
                    label: 'Photo',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Pick photo
                    },
                  ),
                  _AttachmentButton(
                    icon: Icons.videocam_outlined,
                    label: 'Video',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Pick video
                    },
                  ),
                  _AttachmentButton(
                    icon: Icons.file_present_outlined,
                    label: 'File',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Pick file
                    },
                  ),
                  _AttachmentButton(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Share location
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _AttachmentButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyLarge?.color,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
