import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../../core/navigation/routes.dart';
import '../../../data/models/server_model.dart';

class ServerPage extends ConsumerStatefulWidget {
  final String serverId;
  final String? channelId;
  
  const ServerPage({
    super.key,
    required this.serverId,
    this.channelId,
  });

  @override
  ConsumerState<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends ConsumerState<ServerPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 768;
    
    if (isWideScreen) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildServerSidebar(),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: _buildChannelContent(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: _buildServerAppBar(),
      drawer: Drawer(
        child: _buildServerSidebar(),
      ),
      body: _buildChannelContent(),
    );
  }

  PreferredSizeWidget _buildServerAppBar() {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      title: const Text('Server Name'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Search in server
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Show server menu
          },
        ),
      ],
    );
  }

  Widget _buildServerSidebar() {
    final theme = Theme.of(context);
    
    return Container(
      width: 240,
      color: theme.cardTheme.color,
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerTheme.color!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.group,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Server Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _ChannelCategory(
                  name: 'TEXT CHANNELS',
                  channels: [
                    _ChannelItem(
                      name: 'general',
                      icon: Icons.tag,
                      isSelected: widget.channelId == null || widget.channelId == 'general',
                      onTap: () {
                        context.go(AppRoutes.serverPath(widget.serverId));
                      },
                    ),
                    _ChannelItem(
                      name: 'random',
                      icon: Icons.tag,
                      isSelected: widget.channelId == 'random',
                      onTap: () {
                        context.go(AppRoutes.channelPath(widget.serverId, 'random'));
                      },
                    ),
                    _ChannelItem(
                      name: 'announcements',
                      icon: Icons.announcement_outlined,
                      isSelected: widget.channelId == 'announcements',
                      onTap: () {
                        context.go(AppRoutes.channelPath(widget.serverId, 'announcements'));
                      },
                    ),
                  ],
                ),
                _ChannelCategory(
                  name: 'VOICE CHANNELS',
                  channels: [
                    _ChannelItem(
                      name: 'General',
                      icon: Icons.volume_up,
                      isSelected: false,
                      onTap: () {
                        // TODO: Join voice channel
                      },
                    ),
                    _ChannelItem(
                      name: 'Music',
                      icon: Icons.music_note,
                      isSelected: false,
                      onTap: () {
                        // TODO: Join voice channel
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerTheme.color!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_voice_outlined),
                  onPressed: () {
                    // TODO: Voice settings
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelContent() {
    final theme = Theme.of(context);
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerTheme.color!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.tag, color: theme.textTheme.bodyMedium?.color),
                const SizedBox(width: 8),
                Text(
                  widget.channelId ?? 'general',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                    
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.person_add_outlined),
                  onPressed: () {
                    // TODO: Invite people
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Welcome to #${widget.channelId ?? 'general'}',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.textTheme.bodyMedium?.color,
                  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelCategory extends StatelessWidget {
  final String name;
  final List<_ChannelItem> channels;
  
  const _ChannelCategory({
    required this.name,
    required this.channels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.expand_more, size: 16),
              const SizedBox(width: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  
                ),
              ),
            ],
          ),
        ),
        ...channels,
      ],
    );
  }
}

class _ChannelItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _ChannelItem({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? theme.primaryColor
                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? theme.textTheme.bodyLarge?.color
                    : theme.textTheme.bodyMedium?.color,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
