import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/auth_service.dart';

const _tokenKey = 'auth_token';

class AuthState {
  final String? token;
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;

  const AuthState({
    this.token,
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({
    String? token,
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
  }) {
    return AuthState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage,
    );
  }
}

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _loadToken();
    return const AuthState(isLoading: true, isInitialized: false);
  }

  Future<void> _loadToken() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: _tokenKey);
    state = state.copyWith(
      token: token,
      isLoading: false,
      isInitialized: true,
      errorMessage: null,
    );
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final token = await ref
          .read(authServiceProvider)
          .login(username: username, password: password);
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _tokenKey, value: token);
      state = state.copyWith(
        token: token,
        isLoading: false,
        isInitialized: true,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed. Please check your credentials.',
      );
      rethrow;
    }
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref
          .read(authServiceProvider)
          .register(username: username, password: password);
      await login(username: username, password: password);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed. Try a different username.',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      final storage = ref.read(secureStorageProvider);
      await storage.delete(key: _tokenKey);
      state = const AuthState(
        token: null,
        isLoading: false,
        isInitialized: true,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
