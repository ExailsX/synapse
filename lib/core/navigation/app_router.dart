import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import '../../features/auth/login/login_page.dart';
import '../../features/auth/register/register_page.dart';
import '../../features/auth/verify_email/verify_email_page.dart';
import '../../features/home/home_page.dart';
import '../../features/chats/chat/chat_page.dart';
import '../../features/servers/server/server_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/search/search_page.dart';
import '../../state/auth/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = _isAuthRoute(state.matchedLocation);
      
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }
      
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.home;
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Scaffold(
          backgroundColor: Color(0xFF1E1F22),
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5865F2),
            ),
          ),
        ),
      ),
      
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: 'verify-email',
            builder: (context, state) => const VerifyEmailPage(),
          ),
        ],
      ),
      
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailPage(),
      ),
      
      ShellRoute(
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) {
              return const Center(
                child: Text(
                  'Welcome to Messenger',
                  style: TextStyle(
                    
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          
          GoRoute(
            path: AppRoutes.chat,
            builder: (context, state) {
              final chatId = state.pathParameters['chatId']!;
              return ChatPage(chatId: chatId);
            },
          ),
          
          GoRoute(
            path: AppRoutes.server,
            builder: (context, state) {
              final serverId = state.pathParameters['serverId']!;
              return ServerPage(serverId: serverId);
            },
          ),
          
          GoRoute(
            path: AppRoutes.channel,
            builder: (context, state) {
              final serverId = state.pathParameters['serverId']!;
              final channelId = state.pathParameters['channelId']!;
              return ServerPage(
                serverId: serverId,
                channelId: channelId,
              );
            },
          ),
          
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
          
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SearchPage(),
          ),
        ],
      ),
    ],
  );
});

bool _isAuthRoute(String location) {
  return location.startsWith(AppRoutes.login) ||
         location.startsWith(AppRoutes.register) ||
         location.startsWith(AppRoutes.verifyEmail);
}
