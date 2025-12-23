import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/routes.dart';
import '../../../data/models/user_model.dart';
import '../../../state/auth/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).currentUser;
    
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.primaryColor.withOpacity(0.3),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: theme.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          user.initials,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                        
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.statusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: user.statusColor,
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
                _ProfileSection(
                  title: 'Account Information',
                  children: [
                    _ProfileItem(
                      icon: Icons.person_outline,
                      title: 'Username',
                      subtitle: user.username,
                      onTap: () {
                        _showEditDialog(
                          context,
                          'Edit Username',
                          user.username,
                          (value) {
                            // TODO: Update username
                          },
                        );
                      },
                    ),
                    if (user.email != null)
                      _ProfileItem(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: user.email!,
                        onTap: () {
                          _showEditDialog(
                            context,
                            'Edit Email',
                            user.email!,
                            (value) {
                              // TODO: Update email
                            },
                          );
                        },
                      ),
                    _ProfileItem(
                      icon: Icons.lock_outline,
                      title: 'Password',
                      subtitle: 'Tap to change password',
                      onTap: () {
                        // TODO: Show change password dialog
                      },
                    ),
                  ],
                ),
                _ProfileSection(
                  title: 'Status',
                  children: [
                    _ProfileItem(
                      icon: Icons.circle,
                      title: 'Online Status',
                      subtitle: user.status.displayName,
                      trailing: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: user.statusColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onTap: () {
                        _showStatusDialog(context, ref);
                      },
                    ),
                  ],
                ),
                _ProfileSection(
                  title: 'Security',
                  children: [
                    _ProfileItem(
                      icon: Icons.devices_outlined,
                      title: 'Active Sessions',
                      subtitle: 'Manage your devices',
                      onTap: () {
                        // TODO: Navigate to sessions page
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.history_outlined,
                      title: 'Login History',
                      subtitle: 'View recent logins',
                      onTap: () {
                        // TODO: Navigate to login history
                      },
                    ),
                  ],
                ),
                _ProfileSection(
                  title: 'Actions',
                  children: [
                    _ProfileItem(
                      icon: Icons.logout_outlined,
                      title: 'Sign Out',
                      subtitle: 'Sign out from all devices',
                      textColor: Colors.red,
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                              'Are you sure you want to sign out from all devices?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirmed == true && context.mounted) {
                          final authNotifier = ref.read(authProvider.notifier);
                          await authNotifier.logout();
                          if (context.mounted) {
                            context.go(AppRoutes.login);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Set Status'),
        children: UserStatus.values.map((status) {
          return ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            title: Text(status.displayName),
            onTap: () {
              // TODO: Update status
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return const Color(0xFF3BA55C);
      case UserStatus.away:
        return const Color(0xFFFAA81A);
      case UserStatus.doNotDisturb:
        return const Color(0xFFF38688);
      case UserStatus.offline:
        return const Color(0xFF949BA4);
      default:
        return const Color(0xFF949BA4);
    }
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  
  const _ProfileSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              
            ),
          ),
        ),
        ...children,
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? textColor;
  final VoidCallback onTap;
  
  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor ?? theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? theme.textTheme.bodyLarge?.color,
                      
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor?.withOpacity(0.7) ??
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 12),
            ],
            Icon(
              Icons.chevron_right,
              size: 24,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
