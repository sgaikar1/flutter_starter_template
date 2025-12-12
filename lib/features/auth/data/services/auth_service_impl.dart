import '../../../../core/errors/app_error.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_service.dart';
import '../models/user_dto.dart';

/// Mock implementation of AuthService for development.
///
/// TODO: Replace with actual API calls in production.
class AuthServiceImpl implements AuthService {
  AuthServiceImpl({
    required ApiClient apiClient,
    required StorageService storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final ApiClient _apiClient;
  final StorageService _storage;
  final _logger = AppLogger.auth;

  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Future<void> initialize() async {
    try {
      // Try to load saved user and token
      final token = await _storage.getString(StorageKeys.authToken);
      final userId = await _storage.getString(StorageKeys.userId);

      if (token != null && userId != null) {
        _apiClient.setAuthToken(token);

        // In a real app, you'd validate the token or fetch user data
        // For now, create a mock user
        _currentUser = User(
          id: userId,
          email: 'saved@example.com',
          name: 'Saved User',
        );

        _logger.info('Restored user session');
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to initialize auth',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting login for: $email');

      // Mock implementation - accepts any email/password
      // In production, this would make an API call:
      // final result = await _apiClient.post<LoginResponseDto>(
      //   '/auth/login',
      //   body: {'email': email, 'password': password},
      //   fromJson: LoginResponseDto.fromJson,
      // );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Create mock user
      final mockUser = User(
        id: 'user_${email.hashCode}',
        email: email,
        name: _getNameFromEmail(email),
      );

      final mockToken =
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
      final mockRefreshToken =
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save tokens and user ID
      await _storage.setString(StorageKeys.authToken, mockToken);
      await _storage.setString(StorageKeys.refreshToken, mockRefreshToken);
      await _storage.setString(StorageKeys.userId, mockUser.id);

      // Set auth token in API client
      _apiClient.setAuthToken(mockToken);

      _currentUser = mockUser;
      _logger.info('Login successful');

      return Success(mockUser);
    } catch (e, stackTrace) {
      _logger.error('Login failed', error: e, stackTrace: stackTrace);
      return Failure(
        AuthenticationError(
          message: 'Login failed. Please try again.',
          code: 'LOGIN_FAILED',
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      _logger.info('Logging out user: ${_currentUser?.email}');

      // In production, call logout endpoint
      // await _apiClient.post('/auth/logout');

      // Clear tokens
      await _storage.remove(StorageKeys.authToken);
      await _storage.remove(StorageKeys.refreshToken);
      await _storage.remove(StorageKeys.userId);

      // Clear API client token
      _apiClient.clearAuthToken();

      _currentUser = null;
      _logger.info('Logout successful');
    } catch (e, stackTrace) {
      _logger.error('Logout error', error: e, stackTrace: stackTrace);
      // Still clear local state even if API call fails
      _currentUser = null;
    }
  }

  @override
  Future<ApiResult<void>> refreshToken() async {
    try {
      final refreshToken = await _storage.getString(StorageKeys.refreshToken);
      if (refreshToken == null) {
        return Failure(
          AuthenticationError(
            message: 'No refresh token available',
            code: 'NO_REFRESH_TOKEN',
          ),
        );
      }

      _logger.info('Refreshing auth token');

      // In production, call refresh endpoint:
      // final result = await _apiClient.post<LoginResponseDto>(
      //   '/auth/refresh',
      //   body: {'refresh_token': refreshToken},
      //   fromJson: LoginResponseDto.fromJson,
      // );

      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));

      final newToken =
          'refreshed_mock_token_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.setString(StorageKeys.authToken, newToken);
      _apiClient.setAuthToken(newToken);

      _logger.info('Token refresh successful');
      return const Success(null);
    } catch (e, stackTrace) {
      _logger.error('Token refresh failed', error: e, stackTrace: stackTrace);
      return Failure(AuthenticationError.tokenExpired());
    }
  }

  /// Extracts a name from an email address
  String _getNameFromEmail(String email) {
    final username = email.split('@').first;
    final parts = username.split('.');
    return parts.map((p) => _capitalize(p)).join(' ');
  }

  String _capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }
}
