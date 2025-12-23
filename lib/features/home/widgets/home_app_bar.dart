import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/routes.dart';
import '../../../state/auth/auth_provider.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  
  const HomeAppBar({
    super.key,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;
    
    String title = 'Messenger';
    if (location.startsWith('/chat')) {
      title = 'Chat';
    } else if (location.startsWith('/server')) {
      title = 'Server';
    } else if (location.startsWith('/profile')) {
      title = 'Profile';
    } else if (location.startsWith('/settings')) {
      title = 'Settings';
    }

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.go(AppRoutes.search);
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
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_outlined, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) {
            switch (value) {
              case 'profile':
                context.go(AppRoutes.profile);
                break;
              case 'settings':
                context.go(AppRoutes.settings);
                break;
              case 'logout':
                _handleLogout(ref, context);
                break;
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _handleLogout(WidgetRef ref, BuildContext context) async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.logout();
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}
