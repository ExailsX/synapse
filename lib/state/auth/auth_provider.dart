import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/token_storage.dart';
import '../../data/services/api_service.dart';
import '../../data/models/user_model.dart';
import '../../core/config/app_config.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  
  AuthNotifier(this._ref) : super(const AuthState()) {
    _init();
  }
  
  Future<void> _init() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenStorage = TokenStorage(prefs);
      final hasToken = await tokenStorage.hasValidToken();

      if (hasToken && !AppConfig.useLocalMode) {
        final apiService = _ref.read(apiServiceProvider);
        final user = await apiService.getCurrentUser();

        state = state.copyWith(
          isAuthenticated: true,
          currentUser: user,
          isLoading: false,
        );
      } else if (AppConfig.useLocalMode) {
        // In local mode, try to auto-login with local credentials
        await login(identifier: 'testuser', password: 'testpass123');
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      final tokenStorage = _ref.read(tokenStorageProvider);
      
      final response = await apiService.login(
        identifier: identifier,
        password: password,
      );
      
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.user.id,
      );
      
      state = state.copyWith(
        isAuthenticated: true,
        currentUser: response.user,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
  
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final apiService = _ref.read(apiServiceProvider);
      
      await apiService.register(
        username: username,
        email: email,
        password: password,
      );
      
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
  
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final tokenStorage = _ref.read(tokenStorageProvider);
      await tokenStorage.clear();
      
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  void updateUser(User user) {
    state = state.copyWith(currentUser: user);
  }
}

class AuthState {
  final bool isAuthenticated;
  final User? currentUser;
  final bool isLoading;
  final String? error;
  
  const AuthState({
    this.isAuthenticated = false,
    this.currentUser,
    this.isLoading = false,
    this.error,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    User? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  throw UnimplementedError('Must be overridden in bootstrap');
});

final apiServiceProvider = Provider<ApiService>((ref) {
  throw UnimplementedError('Must be overridden in bootstrap');
});
