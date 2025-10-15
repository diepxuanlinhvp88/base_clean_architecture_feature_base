import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.dioClient,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final DioClient dioClient;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.login(
          email: email,
          password: password,
        );
        
        // Cache user data
        await localDataSource.cacheUser(userModel);
        
        return Right(userModel.toEntity());
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on CacheException catch (e) {
        return Left(CacheFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.register(
          email: email,
          password: password,
          name: name,
        );
        
        // Cache user data
        await localDataSource.cacheUser(userModel);
        
        return Right(userModel.toEntity());
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on CacheException catch (e) {
        return Left(CacheFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      
      // Clear local data
      await localDataSource.clearCache();
      await localDataSource.clearTokens();
      
      return const Right(null);
    } on DioException catch (e) {
      // Even if remote logout fails, clear local data
      await localDataSource.clearCache();
      await localDataSource.clearTokens();
      return Left(_handleDioError(e));
    } on CacheException catch (e) {
      return Left(CacheFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // First try to get from cache
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      // If not in cache and connected, try remote
      if (await networkInfo.isConnected) {
        final userModel = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(userModel);
        return Right(userModel.toEntity());
      }

      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(UnknownFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await localDataSource.getAccessToken();
      return token != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.refreshToken();
        return const Right(null);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendPasswordResetEmail(email: email);
        return const Right(null);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(
          token: token,
          newPassword: newPassword,
        );
        return const Right(null);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.updateProfile(
          userId: userId,
          name: name,
          phone: phone,
          avatar: avatar,
        );
        
        // Update cache
        await localDataSource.cacheUser(userModel);
        
        return Right(userModel.toEntity());
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on CacheException catch (e) {
        return Left(CacheFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount();
        
        // Clear local data
        await localDataSource.clearCache();
        await localDataSource.clearTokens();
        
        return const Right(null);
      } on DioException catch (e) {
        return Left(_handleDioError(e));
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on CacheException catch (e) {
        return Left(CacheFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(UnknownFailure(
          message: e.toString(),
        ));
      }
    } else {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }
  }

  /// Handle Dio errors and convert to appropriate failures
  Failure _handleDioError(DioException error) {
    try {
      dioClient.handleError(error);
    } on NetworkException catch (e) {
      return NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
      );
    } on ServerException catch (e) {
      return ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      );
    } on AuthException catch (e) {
      return AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
      );
    } on PermissionException catch (e) {
      return PermissionFailure(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      return UnknownFailure(
        message: e.toString(),
      );
    }
  }
}
