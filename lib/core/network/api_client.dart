import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../errors/app_error.dart';
import 'api_result.dart';

/// HTTP client wrapper with error handling and retry logic.
/// 
/// This client provides a clean interface for making HTTP requests
/// with automatic error handling, timeout management, and retry logic.
class ApiClient {
  ApiClient({
    required String baseUrl,
    Duration timeout = const Duration(seconds: 30),
    int maxRetries = 3,
    http.Client? client,
  })  : _baseUrl = baseUrl,
        _timeout = timeout,
        _maxRetries = maxRetries,
        _client = client ?? http.Client();

  final String _baseUrl;
  final Duration _timeout;
  final int _maxRetries;
  final http.Client _client;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Sets the authorization token for all requests
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  /// Removes the authorization token
  void clearAuthToken() {
    _headers.remove('Authorization');
  }

  /// Makes a GET request
  Future<ApiResult<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest(
      () => _client.get(
        _buildUri(endpoint, queryParameters),
        headers: _headers,
      ),
      fromJson: fromJson,
    );
  }

  /// Makes a POST request
  Future<ApiResult<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest(
      () => _client.post(
        _buildUri(endpoint),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ),
      fromJson: fromJson,
    );
  }

  /// Makes a PUT request
  Future<ApiResult<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest(
      () => _client.put(
        _buildUri(endpoint),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ),
      fromJson: fromJson,
    );
  }

  /// Makes a DELETE request
  Future<ApiResult<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest(
      () => _client.delete(
        _buildUri(endpoint),
        headers: _headers,
      ),
      fromJson: fromJson,
    );
  }

  /// Makes the actual HTTP request with retry logic
  Future<ApiResult<T>> _makeRequest<T>(
    Future<http.Response> Function() request, {
    T Function(Map<String, dynamic>)? fromJson,
    int retryCount = 0,
  }) async {
    try {
      final response = await request().timeout(_timeout);

      developer.log(
        'API Request: ${response.request?.method} ${response.request?.url} - Status: ${response.statusCode}',
        name: 'network',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _handleSuccess<T>(response, fromJson);
      } else {
        return _handleError<T>(response);
      }
    } on TimeoutException {
      if (retryCount < _maxRetries) {
        developer.log(
          'Request timeout, retrying... (${retryCount + 1}/$_maxRetries)',
          name: 'network',
        );
        return _makeRequest(
          request,
          fromJson: fromJson,
          retryCount: retryCount + 1,
        );
      }
      return Failure(NetworkError.timeout());
    } on SocketException {
      return Failure(NetworkError.noInternet());
    } on http.ClientException catch (e) {
      developer.log(
        'Client error: ${e.message}',
        name: 'network',
        error: e,
      );
      return Failure(
        NetworkError(
          message: e.message ?? 'Client error occurred',
          code: 'CLIENT_ERROR',
        ),
      );
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error during API call',
        name: 'network',
        error: e,
        stackTrace: stackTrace,
      );
      return Failure(
        GeneralError.unexpected(e.toString()),
      );
    }
  }

  /// Handles successful responses
  ApiResult<T> _handleSuccess<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      // If no fromJson provided, try to return the body as-is
      if (fromJson == null) {
        if (response.body.isEmpty) {
          return Success(null as T);
        }
        return Success(response.body as T);
      }

      // Parse JSON and convert using fromJson
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = fromJson(json);
      return Success(data);
    } catch (e, stackTrace) {
      developer.log(
        'Error parsing response',
        name: 'network',
        error: e,
        stackTrace: stackTrace,
      );
      return Failure(
        GeneralError(
          message: 'Failed to parse response: ${e.toString()}',
          code: 'PARSE_ERROR',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Handles error responses
  Failure<T> _handleError<T>(http.Response response) {
    developer.log(
      'API Error: ${response.statusCode} - ${response.body}',
      name: 'network',
    );

    final statusCode = response.statusCode;

    if (statusCode == 401) {
      return Failure(AuthenticationError.unauthorized());
    }

    if (statusCode == 404) {
      return Failure(GeneralError.notFound('Resource'));
    }

    String errorMessage = 'Server error occurred';
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      errorMessage = json['message'] as String? ?? errorMessage;
    } catch (_) {
      // Failed to parse error message, use default
    }

    return Failure(
      NetworkError.serverError(errorMessage),
    );
  }

  /// Builds the complete URI with base URL and query parameters
  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$_baseUrl$path').replace(
      queryParameters: queryParameters,
    );
  }

  /// Disposes the client
  void dispose() {
    _client.close();
  }
}
