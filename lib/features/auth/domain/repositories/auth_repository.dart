import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Refresh authentication token
  Future<Either<Failure, void>> refreshToken();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();
}
