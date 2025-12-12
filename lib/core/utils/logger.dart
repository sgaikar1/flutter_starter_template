import 'dart:developer' as developer;

/// Simple logger utility using dart:developer
class Logger {
  const Logger(this.name);

  final String name;

  /// Logs a debug message
  void debug(String message, {Object? data}) {
    developer.log(
      message,
      name: name,
      level: 500,
      error: data,
    );
  }

  /// Logs an info message
  void info(String message, {Object? data}) {
    developer.log(
      message,
      name: name,
      level: 800,
      error: data,
    );
  }

  /// Logs a warning message
  void warning(String message, {Object? error}) {
    developer.log(
      message,
      name: name,
      level: 900,
      error: error,
    );
  }

  /// Logs an error message
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a fatal error message
  void fatal(
    String message, {
    required Object error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: 1200,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Global logger instances for different parts of the app
class AppLogger {
  static const network = Logger('network');
  static const auth = Logger('auth');
  static const storage = Logger('storage');
  static const ui = Logger('ui');
  static const app = Logger('app');
}
