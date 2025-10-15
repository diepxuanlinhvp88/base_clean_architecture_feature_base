import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import 'injection_container.config.dart';

/// Service locator instance
final GetIt getIt = GetIt.instance;

/// Configure dependency injection
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Setup core dependencies that need async initialization
@module
abstract class CoreModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => 
      SharedPreferences.getInstance();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  DioClient get dioClient => DioClient();

  @singleton
  Dio dio(DioClient dioClient) => dioClient.dio;

  @singleton
  NetworkInfo networkInfo(Connectivity connectivity) => 
      NetworkInfoImpl(connectivity);
}
