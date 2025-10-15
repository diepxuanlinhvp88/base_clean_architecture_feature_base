/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException: $message';
}

/// Server exception - thrown when server returns an error
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ServerException: $message';
}

/// Cache exception - thrown when there's an issue with local storage
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Network exception - thrown when there's no internet connection
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Validation exception - thrown when input validation fails
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Authentication exception - thrown when authentication fails
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'AuthException: $message';
}

/// Permission exception - thrown when user doesn't have required permissions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'PermissionException: $message';
}
