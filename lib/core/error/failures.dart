import 'package:equatable/equatable.dart';

/// Abstract class for all failures in the application
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server failure - when there's an issue with the server
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

/// Cache failure - when there's an issue with local storage
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
  });
}

/// Network failure - when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
  });
}

/// Validation failure - when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.statusCode,
  });
}

/// Authentication failure - when authentication fails
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
  });
}

/// Permission failure - when user doesn't have required permissions
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.statusCode,
  });
}

/// Unknown failure - for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.statusCode,
  });
}
