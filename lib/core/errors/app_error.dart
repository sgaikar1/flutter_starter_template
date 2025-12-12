/// Base class for all application errors
abstract class AppError implements Exception {
  const AppError({
    required this.message,
    this.code,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppError: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related errors
class NetworkError extends AppError {
  const NetworkError({
    required super.message,
    super.code,
    super.stackTrace,
  });

  factory NetworkError.noInternet() {
    return const NetworkError(
      message: 'No internet connection',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkError.timeout() {
    return const NetworkError(
      message: 'Request timeout',
      code: 'TIMEOUT',
    );
  }

  factory NetworkError.serverError([String? details]) {
    return NetworkError(
      message: details ?? 'Server error occurred',
      code: 'SERVER_ERROR',
    );
  }
}

/// Authentication-related errors
class AuthenticationError extends AppError {
  const AuthenticationError({
    required super.message,
    super.code,
    super.stackTrace,
  });

  factory AuthenticationError.invalidCredentials() {
    return const AuthenticationError(
      message: 'Invalid email or password',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthenticationError.tokenExpired() {
    return const AuthenticationError(
      message: 'Session expired. Please login again.',
      code: 'TOKEN_EXPIRED',
    );
  }

  factory AuthenticationError.unauthorized() {
    return const AuthenticationError(
      message: 'Unauthorized access',
      code: 'UNAUTHORIZED',
    );
  }
}

/// Validation-related errors
class ValidationError extends AppError {
  const ValidationError({
    required super.message,
    super.code,
    super.stackTrace,
    this.field,
  });

  final String? field;

  factory ValidationError.required(String field) {
    return ValidationError(
      message: '$field is required',
      code: 'REQUIRED_FIELD',
      field: field,
    );
  }

  factory ValidationError.invalidFormat(String field) {
    return ValidationError(
      message: '$field has invalid format',
      code: 'INVALID_FORMAT',
      field: field,
    );
  }
}

/// Cache-related errors
class CacheError extends AppError {
  const CacheError({
    required super.message,
    super.code,
    super.stackTrace,
  });

  factory CacheError.notFound() {
    return const CacheError(
      message: 'Data not found in cache',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheError.writeFailure() {
    return const CacheError(
      message: 'Failed to write to cache',
      code: 'CACHE_WRITE_FAILURE',
    );
  }
}

/// General application errors
class GeneralError extends AppError {
  const GeneralError({
    required super.message,
    super.code,
    super.stackTrace,
  });

  factory GeneralError.unexpected([String? details]) {
    return GeneralError(
      message: details ?? 'An unexpected error occurred',
      code: 'UNEXPECTED_ERROR',
    );
  }

  factory GeneralError.notFound(String resource) {
    return GeneralError(
      message: '$resource not found',
      code: 'NOT_FOUND',
    );
  }
}
