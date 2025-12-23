import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/routes.dart';

class ServerListPage extends ConsumerWidget {
  const ServerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Servers'),
            pinned: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_outlined),
                onPressed: () {
                  _showCreateServerDialog(context);
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ServerItem(
                  name: 'General Server',
                  description: 'A place for general discussion',
                  memberCount: 1247,
                  icon: Icons.group,
                  onTap: () {
                    context.go(AppRoutes.serverPath('server1'));
                  },
                ),
                _ServerItem(
                  name: 'Tech Talk',
                  description: 'Technology and programming',
                  memberCount: 892,
                  icon: Icons.code,
                  onTap: () {
                    context.go(AppRoutes.serverPath('server2'));
                  },
                ),
                _ServerItem(
                  name: 'Gaming Hub',
                  description: 'All about gaming',
                  memberCount: 2156,
                  icon: Icons.games,
                  onTap: () {
                    context.go(AppRoutes.serverPath('server3'));
                  },
                ),
                _ServerItem(
                  name: 'Study Group',
                  description: 'Learning together',
                  memberCount: 456,
                  icon: Icons.school,
                  onTap: () {
                    context.go(AppRoutes.serverPath('server4'));
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateServerDialog(context);
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateServerDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Server'),
        content: const Text('Create a new server for your community.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to server creation flow
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _ServerItem extends StatelessWidget {
  final String name;
  final String description;
  final int memberCount;
  final IconData icon;
  final VoidCallback onTap;
  
  const _ServerItem({
    required this.name,
    required this.description,
    required this.memberCount,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerTheme.color!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                      
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outlined,
                        size: 16,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$memberCount members',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
