import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/user_model.dart';

part 'auth_remote_datasource.g.dart';

/// Abstract class for authentication remote data source
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<void> refreshToken();

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? avatar,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount();
}

/// Implementation of AuthRemoteDataSource using Retrofit
@RestApi()
@Injectable(as: AuthRemoteDataSource)
abstract class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @factoryMethod
  factory AuthRemoteDataSourceImpl(Dio dio) = _AuthRemoteDataSourceImpl;

  @override
  @POST('/auth/login')
  Future<UserModel> login({
    @Field() required String email,
    @Field() required String password,
  });

  @override
  @POST('/auth/register')
  Future<UserModel> register({
    @Field() required String email,
    @Field() required String password,
    @Field() required String name,
  });

  @override
  @POST('/auth/logout')
  Future<void> logout();

  @override
  @GET('/auth/me')
  Future<UserModel> getCurrentUser();

  @override
  @POST('/auth/refresh')
  Future<void> refreshToken();

  @override
  @POST('/auth/forgot-password')
  Future<void> sendPasswordResetEmail({
    @Field() required String email,
  });

  @override
  @POST('/auth/reset-password')
  Future<void> resetPassword({
    @Field() required String token,
    @Field() required String newPassword,
  });

  @override
  @PUT('/auth/profile/{userId}')
  Future<UserModel> updateProfile({
    @Path() required String userId,
    @Field() String? name,
    @Field() String? phone,
    @Field() String? avatar,
  });

  @override
  @PUT('/auth/change-password')
  Future<void> changePassword({
    @Field() required String currentPassword,
    @Field() required String newPassword,
  });

  @override
  @DELETE('/auth/account')
  Future<void> deleteAccount();
}
