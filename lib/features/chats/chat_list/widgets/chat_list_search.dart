import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/common/app_text_field.dart';

class ChatListSearch extends ConsumerStatefulWidget {
  const ChatListSearch({super.key});

  @override
  ConsumerState<ChatListSearch> createState() => _ChatListSearchState();
}

class _ChatListSearchState extends ConsumerState<ChatListSearch> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AppTextField(
        controller: _searchController,
        hintText: 'Search chats...',
        prefixIcon: Icon(Icons.search),
        onChanged: (value) {
          // TODO: Implement search functionality
        },
      ),
    );
  }
}
