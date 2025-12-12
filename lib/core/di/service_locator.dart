import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/services/auth_service_impl.dart';
import '../../features/auth/domain/repositories/auth_service.dart';
import '../config/env_config.dart';
import '../network/api_client.dart';
import '../storage/storage_service.dart';

/// Simple service locator for dependency injection.
/// 
/// This provides a centralized place to create and access app-wide services.
/// For more complex apps, consider using get_it or provider.
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  // Core services
  late final EnvConfig envConfig;
  late final StorageService storageService;
  late final ApiClient apiClient;

  // Feature services
  late final AuthService authService;

  bool _initialized = false;

  /// Initializes all services.
  /// This should be called once at app startup.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    // Load environment config
    envConfig = EnvConfig.getCurrentConfig();

    // Initialize storage
    final prefs = await SharedPreferences.getInstance();
    storageService = SharedPreferencesStorage(prefs);

    // Initialize API client
    apiClient = ApiClient(
      baseUrl: envConfig.apiBaseUrl,
      timeout: Duration(milliseconds: envConfig.apiTimeout),
    );

    // Initialize auth service
    authService = AuthServiceImpl(
      apiClient: apiClient,
      storage: storageService,
    );

    // Load saved auth token if exists
    final token = await storageService.getString(StorageKeys.authToken);
    if (token != null) {
      apiClient.setAuthToken(token);
    }

    _initialized = true;
  }

  /// Resets all services (useful for testing or logout)
  Future<void> reset() async {
    apiClient.dispose();
    await storageService.clear();
    _initialized = false;
  }
}

/// Convenience getter for service locator
ServiceLocator get sl => ServiceLocator.instance;
