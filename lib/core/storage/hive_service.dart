import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// Service for Hive database operations
@singleton
class HiveService {
  Box<T>? _getBox<T>(String boxName) {
    try {
      return Hive.box<T>(boxName);
    } catch (e) {
      return null;
    }
  }

  /// Open a box
  Future<Box<T>> openBox<T>(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<T>(boxName);
      }
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      throw CacheException(
        message: 'Failed to open box: $boxName',
      );
    }
  }

  /// Save data to box
  Future<void> put<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    try {
      final box = await openBox<T>(boxName);
      await box.put(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save data to $boxName',
      );
    }
  }

  /// Get data from box
  Future<T?> get<T>({
    required String boxName,
    required String key,
  }) async {
    try {
      final box = await openBox<T>(boxName);
      return box.get(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get data from $boxName',
      );
    }
  }

  /// Delete data from box
  Future<void> delete({
    required String boxName,
    required String key,
  }) async {
    try {
      final box = await openBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete data from $boxName',
      );
    }
  }

  /// Clear all data from box
  Future<void> clearBox(String boxName) async {
    try {
      final box = await openBox(boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear box: $boxName',
      );
    }
  }

  /// Close a box
  Future<void> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to close box: $boxName',
      );
    }
  }

  /// Save list to box
  Future<void> putList<T>({
    required String boxName,
    required List<T> items,
  }) async {
    try {
      final box = await openBox<T>(boxName);
      await box.clear();
      await box.addAll(items);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save list to $boxName',
      );
    }
  }

  /// Get all items from box as list
  Future<List<T>> getList<T>(String boxName) async {
    try {
      final box = await openBox<T>(boxName);
      return box.values.toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get list from $boxName',
      );
    }
  }

  /// Check if box is empty
  Future<bool> isEmpty(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.isEmpty;
    } catch (e) {
      return true;
    }
  }

  /// Get box length
  Future<int> getLength(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.length;
    } catch (e) {
      return 0;
    }
  }

  /// Check if key exists
  Future<bool> containsKey({
    required String boxName,
    required String key,
  }) async {
    try {
      final box = await openBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Get cache expiration time
  Future<DateTime?> getCacheTime({
    required String boxName,
    required String key,
  }) async {
    try {
      final cacheKey = '${key}_cache_time';
      final timestamp = await get<int>(boxName: boxName, key: cacheKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Set cache expiration time
  Future<void> setCacheTime({
    required String boxName,
    required String key,
  }) async {
    try {
      final cacheKey = '${key}_cache_time';
      await put<int>(
        boxName: boxName,
        key: cacheKey,
        value: DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to set cache time',
      );
    }
  }

  /// Check if cache is expired
  Future<bool> isCacheExpired({
    required String boxName,
    required String key,
    Duration expiration = AppConstants.cacheExpiration,
  }) async {
    final cacheTime = await getCacheTime(boxName: boxName, key: key);
    if (cacheTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    return difference > expiration;
  }

  /// Close all boxes
  Future<void> closeAll() async {
    try {
      await Hive.close();
    } catch (e) {
      throw CacheException(
        message: 'Failed to close all boxes',
      );
    }
  }
}
