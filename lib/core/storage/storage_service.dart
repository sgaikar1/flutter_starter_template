import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for local storage operations
abstract class StorageService {
  /// Gets a string value by key
  Future<String?> getString(String key);

  /// Sets a string value
  Future<bool> setString(String key, String value);

  /// Gets an int value by key
  Future<int?> getInt(String key);

  /// Sets an int value
  Future<bool> setInt(String key, int value);

  /// Gets a bool value by key
  Future<bool?> getBool(String key);

  /// Sets a bool value
  Future<bool> setBool(String key, bool value);

  /// Gets a double value by key
  Future<double?> getDouble(String key);

  /// Sets a double value
  Future<bool> setDouble(String key, double value);

  /// Gets a list of strings by key
  Future<List<String>?> getStringList(String key);

  /// Sets a list of strings
  Future<bool> setStringList(String key, List<String> value);

  /// Removes a value by key
  Future<bool> remove(String key);

  /// Clears all values
  Future<bool> clear();

  /// Checks if a key exists
  Future<bool> containsKey(String key);
}

/// SharedPreferences implementation of StorageService
class SharedPreferencesStorage implements StorageService {
  SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  /// Factory method to create an instance
  static Future<SharedPreferencesStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorage(prefs);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}

/// Storage keys used throughout the app
class StorageKeys {
  static const authToken = 'auth_token';
  static const refreshToken = 'refresh_token';
  static const userId = 'user_id';
  static const onboardingComplete = 'onboarding_complete';
  static const themeMode = 'theme_mode';
  static const locale = 'locale';
}
