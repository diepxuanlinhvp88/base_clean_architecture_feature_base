import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Abstract class for authentication local data source
abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<void> clearTokens();
}

/// Implementation of AuthLocalDataSource using SharedPreferences
@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get cached user data',
      );
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _sharedPreferences.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to cache user data',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _sharedPreferences.remove(AppConstants.userDataKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to clear user cache',
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.accessTokenKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get access token',
      );
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _sharedPreferences.setString(AppConstants.accessTokenKey, token);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to save access token',
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.refreshTokenKey);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to get refresh token',
      );
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _sharedPreferences.setString(AppConstants.refreshTokenKey, token);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to save refresh token',
      );
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _sharedPreferences.remove(AppConstants.accessTokenKey),
        _sharedPreferences.remove(AppConstants.refreshTokenKey),
      ]);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to clear tokens',
      );
    }
  }
}
