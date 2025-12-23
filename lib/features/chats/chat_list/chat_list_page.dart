import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/routes.dart';
import '../../../state/chats/chat_provider.dart';
import '../../../data/models/chat_model.dart';
import 'widgets/chat_list_item.dart';
import 'widgets/chat_list_search.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatsProvider.notifier).loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatState = ref.watch(chatsProvider);
    
    final filteredChats = chatState.chats.where((chat) {
      if (_searchQuery.isEmpty) return true;
      return chat.displayTitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (chatState.isLoading && chatState.chats.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        ChatListSearch(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredChats.length,
            itemBuilder: (context, index) {
              final chat = filteredChats[index];
              return ChatListItem(
                chat: chat,
                onTap: () {
                  context.go(AppRoutes.chatPath(chat.id));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatListSearch extends StatelessWidget {
  final ValueChanged<String> onChanged;
  
  const ChatListSearch({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search chats...',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.cardTheme.color,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
