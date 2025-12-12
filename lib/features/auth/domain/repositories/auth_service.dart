import '../../../../core/network/api_result.dart';
import '../models/user_model.dart';

/// Authentication service interface
abstract class AuthService {
  /// Gets the currently authenticated user, if any
  User? get currentUser;

  /// Returns true if a user is currently authenticated
  bool get isAuthenticated;

  /// Logs in with email and password
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  });

  /// Logs out the current user
  Future<void> logout();

  /// Refreshes the authentication token
  Future<ApiResult<void>> refreshToken();

  /// Initializes the auth service (loads saved session)
  Future<void> initialize();
}
