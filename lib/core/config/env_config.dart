/// Environment types supported by the app
enum Environment {
  dev,
  staging,
  prod;

  /// Returns true if this is a production environment
  bool get isProduction => this == Environment.prod;

  /// Returns true if this is a development environment
  bool get isDevelopment => this == Environment.dev;
}

/// Environment configuration for the app.
/// 
/// TODO: Replace these values with your actual configuration.
/// In production, consider using --dart-define for sensitive values.
class EnvConfig {
  const EnvConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiTimeout,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enableLogging,
    required this.logLevel,
  });

  final Environment environment;
  final String apiBaseUrl;
  final int apiTimeout;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enableLogging;
  final String logLevel;

  /// Development environment configuration
  static const dev = EnvConfig._(
    environment: Environment.dev,
    apiBaseUrl: 'https://api-dev.example.com',
    apiTimeout: 30000,
    enableAnalytics: false,
    enableCrashReporting: false,
    enableLogging: true,
    logLevel: 'debug',
  );

  /// Staging environment configuration
  static const staging = EnvConfig._(
    environment: Environment.staging,
    apiBaseUrl: 'https://api-staging.example.com',
    apiTimeout: 30000,
    enableAnalytics: true,
    enableCrashReporting: true,
    enableLogging: true,
    logLevel: 'info',
  );

  /// Production environment configuration
  static const prod = EnvConfig._(
    environment: Environment.prod,
    apiBaseUrl: 'https://api.example.com',
    apiTimeout: 30000,
    enableAnalytics: true,
    enableCrashReporting: true,
    enableLogging: false,
    logLevel: 'warning',
  );

  /// Gets the current environment configuration.
  /// 
  /// This can be set via:
  /// 1. --dart-define=ENVIRONMENT=prod
  /// 2. Environment variable
  /// 3. Defaults to dev
  static EnvConfig getCurrentConfig() {
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'dev',
    );

    return switch (environment.toLowerCase()) {
      'prod' || 'production' => prod,
      'staging' => staging,
      _ => dev,
    };
  }
}
