import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/routes.dart';
import '../../../state/auth/auth_provider.dart';
import '../chats/chat_list/chat_list_page.dart';
import '../servers/server_list/server_list_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';
import 'widgets/home_sidebar.dart';
import 'widgets/home_app_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  final Widget child;
  
  const HomePage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.path;
      _updateSelectedIndex(location);
    });
  }
  
  void _updateSelectedIndex(String location) {
    if (location.startsWith('/chat') || location == '/home') {
      setState(() {
        _selectedIndex = 0;
      });
    } else if (location.startsWith('/server')) {
      setState(() {
        _selectedIndex = 1;
      });
    } else if (location.startsWith('/profile')) {
      setState(() {
        _selectedIndex = 2;
      });
    } else if (location.startsWith('/settings')) {
      setState(() {
        _selectedIndex = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 768;
    
    if (isWideScreen) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          HomeSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                HomeAppBar(
                  onMenuPressed: () {},
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: HomeAppBar(
        onMenuPressed: () {},
      ),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Servers',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.serverPath('default'));
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }
}
