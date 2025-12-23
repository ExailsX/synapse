import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _previewEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Settings'),
            pinned: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            elevation: 0,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _SettingsSection(
                title: 'Appearance',
                children: [
                  _SettingsItem(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: _getThemeName(themeMode),
                    onTap: () {
                      _showThemeDialog(context, ref);
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.wallpaper_outlined,
                    title: 'Chat Wallpaper',
                    subtitle: 'Change chat background',
                    onTap: () {
                      // TODO: Show wallpaper picker
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.text_fields_outlined,
                    title: 'Font Size',
                    subtitle: 'Medium',
                    onTap: () {
                      // TODO: Show font size picker
                    },
                  ),
                ],
              ),
              _SettingsSection(
                title: 'Notifications',
                children: [
                  _SettingsSwitch(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Show message notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  _SettingsSwitch(
                    icon: Icons.volume_up_outlined,
                    title: 'Sound',
                    subtitle: 'Play notification sound',
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                  ),
                  _SettingsSwitch(
                    icon: Icons.vibration_outlined,
                    title: 'Vibration',
                    subtitle: 'Vibrate on new messages',
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                  ),
                  _SettingsSwitch(
                    icon: Icons.preview_outlined,
                    title: 'Message Preview',
                    subtitle: 'Show message preview in notifications',
                    value: _previewEnabled,
                    onChanged: (value) {
                      setState(() {
                        _previewEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              _SettingsSection(
                title: 'Privacy & Security',
                children: [
                  _SettingsItem(
                    icon: Icons.lock_outline,
                    title: 'Privacy Settings',
                    subtitle: 'Control who can contact you',
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.block_outlined,
                    title: 'Blocked Users',
                    subtitle: 'Manage blocked users',
                    onTap: () {
                      // TODO: Navigate to blocked users
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.security_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add extra security',
                    onTap: () {
                      // TODO: Navigate to 2FA setup
                    },
                  ),
                ],
              ),
              _SettingsSection(
                title: 'Data & Storage',
                children: [
                  _SettingsItem(
                    icon: Icons.storage_outlined,
                    title: 'Storage Usage',
                    subtitle: 'Manage storage',
                    onTap: () {
                      // TODO: Navigate to storage settings
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.data_usage_outlined,
                    title: 'Data Usage',
                    subtitle: 'Network usage',
                    onTap: () {
                      // TODO: Navigate to data usage
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.download_outlined,
                    title: 'Auto-Download',
                    subtitle: 'Media auto-download settings',
                    onTap: () {
                      // TODO: Navigate to auto-download settings
                    },
                  ),
                ],
              ),
              _SettingsSection(
                title: 'Help & Support',
                children: [
                  _SettingsItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    onTap: () {
                      // TODO: Navigate to FAQ
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.contact_support_outlined,
                    title: 'Contact Support',
                    subtitle: 'Get help',
                    onTap: () {
                      // TODO: Navigate to support
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and info',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.read(themeModeProvider);
    
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: ThemeMode.values.map((mode) {
          return RadioListTile<ThemeMode>(
            title: Text(_getThemeName(mode)),
            value: mode,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).state = value;
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Messenger'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text('A modern messaging app built with Flutter.'),
            SizedBox(height: 16),
            Text('© 2024 Messenger Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  
  const _SettingsSection({
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

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
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
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
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
                      color: theme.textTheme.bodyLarge?.color,
                      
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      
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

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
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
                      color: theme.textTheme.bodyLarge?.color,
                      
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
