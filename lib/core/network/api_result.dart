import '../errors/app_error.dart';

/// Represents the result of an API call or operation.
///
/// This is a sealed class with two variants: [Success] and [Failure].
/// Use pattern matching to handle both cases.
///
/// Example:
/// ```dart
/// final result = await apiClient.get<User>('/users/1');
/// switch (result) {
///   case Success(:final data):
///     print('Got user: ${data.name}');
///   case Failure(:final error):
///     print('Error: ${error.message}');
/// }
/// ```
sealed class ApiResult<T> {
  const ApiResult();

  /// Returns true if this is a [Success] result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [Failure] result
  bool get isFailure => this is Failure<T>;

  /// Gets the data if successful, otherwise returns null
  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  /// Gets the error if failed, otherwise returns null
  AppError? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  /// Transforms the data if this is a success
  ApiResult<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      Failure(:final error) => Failure(error),
    };
  }

  /// Executes the appropriate callback based on the result
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final error) => failure(error),
    };
  }
}

/// Represents a successful result with data
final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed result with an error
final class Failure<T> extends ApiResult<T> {
  const Failure(this.error);

  final AppError error;

  @override
  String toString() => 'Failure(error: $error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
