import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// Dio client for making HTTP requests
class DioClient {
  DioClient() {
    _dio = Dio();
    _setupInterceptors();
  }

  late final Dio _dio;
  final Logger _logger = Logger();

  Dio get dio => _dio;

  void _setupInterceptors() {
    // Safely get base URL from environment or use default
    String baseUrl = AppConstants.defaultBaseUrl;
    try {
      baseUrl = dotenv.env['BASE_URL'] ?? AppConstants.defaultBaseUrl;
    } catch (e) {
      // DotEnv not initialized, use default
      baseUrl = AppConstants.defaultBaseUrl;
    }

    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('REQUEST: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          if (options.data != null) {
            _logger.d('Body: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          _logger.d('Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('ERROR: ${error.message}');
          _logger.e('Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    // Add auth interceptor if needed
    _dio.interceptors.add(_AuthInterceptor());
  }

  /// Handle Dio errors and convert them to custom exceptions
  Never handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessage(error.response?.data);
        
        if (statusCode != null && statusCode >= 500) {
          throw ServerException(
            message: message ?? 'Server error occurred',
            statusCode: statusCode,
          );
        } else if (statusCode == 401) {
          throw const AuthException(
            message: 'Unauthorized access',
            statusCode: 401,
          );
        } else if (statusCode == 403) {
          throw const PermissionException(
            message: 'Access forbidden',
            statusCode: 403,
          );
        } else {
          throw ServerException(
            message: message ?? 'An error occurred',
            statusCode: statusCode,
          );
        }
      case DioExceptionType.cancel:
        throw const NetworkException(
          message: 'Request was cancelled',
        );
      case DioExceptionType.connectionError:
        throw const NetworkException(
          message: 'No internet connection',
        );
      case DioExceptionType.badCertificate:
        throw const NetworkException(
          message: 'Certificate verification failed',
        );
      case DioExceptionType.unknown:
        throw NetworkException(
          message: error.message ?? 'Unknown network error',
        );
    }
  }

  String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? 
             data['error'] as String? ?? 
             data['detail'] as String?;
    }
    return null;
  }
}

/// Auth interceptor for adding authentication headers
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication token if available
    // You can get token from secure storage or shared preferences
    // final token = await _getAuthToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token refresh logic here if needed
    if (err.response?.statusCode == 401) {
      // Token expired, refresh token logic
      // _refreshToken();
    }
    
    handler.next(err);
  }
}
