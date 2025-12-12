import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_result.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_service.dart';

part 'auth_notifier.g.dart';

/// Authentication state using sealed classes for type-safe state management
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}

/// Auth notifier provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = sl.authService;
    _initialize();
    return const AuthState.initial();
  }

  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;

  /// Initializes auth state
  Future<void> _initialize() async {
    try {
      await _authService.initialize();
      if (isAuthenticated) {
        state = AuthState.authenticated(currentUser!);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Attempts to log in
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = const AuthState.error('Email and password are required');
      return;
    }

    state = const AuthState.loading();

    final result = await _authService.login(email: email, password: password);

    switch (result) {
      case Success(:final data):
        state = AuthState.authenticated(data);
      case Failure(:final error):
        state = AuthState.error(error.message);
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    state = const AuthState.loading();
    await _authService.logout();
    state = const AuthState.unauthenticated();
  }
}
