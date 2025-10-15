// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_clean_architecture/core/di/injection_container.dart'
    as _i573;
import 'package:base_clean_architecture/core/network/dio_client.dart' as _i493;
import 'package:base_clean_architecture/core/network/network_info.dart'
    as _i774;
import 'package:base_clean_architecture/features/auth/data/datasources/auth_local_datasource.dart'
    as _i602;
import 'package:base_clean_architecture/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i707;
import 'package:base_clean_architecture/features/auth/data/repositories/auth_repository_impl.dart'
    as _i355;
import 'package:base_clean_architecture/features/auth/domain/repositories/auth_repository.dart'
    as _i752;
import 'package:base_clean_architecture/features/auth/domain/usecases/login_usecase.dart'
    as _i1054;
import 'package:base_clean_architecture/features/auth/domain/usecases/register_usecase.dart'
    as _i397;
import 'package:base_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart'
    as _i452;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final coreModule = _$CoreModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => coreModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i895.Connectivity>(() => coreModule.connectivity);
    gh.singleton<_i493.DioClient>(() => coreModule.dioClient);
    gh.singleton<_i774.NetworkInfo>(
        () => coreModule.networkInfo(gh<_i895.Connectivity>()));
    gh.singleton<_i361.Dio>(() => coreModule.dio(gh<_i493.DioClient>()));
    gh.factory<_i707.AuthRemoteDataSource>(
        () => _i707.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i602.AuthLocalDataSource>(
        () => _i602.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i752.AuthRepository>(() => _i355.AuthRepositoryImpl(
          remoteDataSource: gh<_i707.AuthRemoteDataSource>(),
          localDataSource: gh<_i602.AuthLocalDataSource>(),
          networkInfo: gh<_i774.NetworkInfo>(),
          dioClient: gh<_i493.DioClient>(),
        ));
    gh.factory<_i1054.LoginUseCase>(
        () => _i1054.LoginUseCase(gh<_i752.AuthRepository>()));
    gh.factory<_i397.RegisterUseCase>(
        () => _i397.RegisterUseCase(gh<_i752.AuthRepository>()));
    gh.factory<_i452.AuthBloc>(() => _i452.AuthBloc(
          loginUseCase: gh<_i1054.LoginUseCase>(),
          registerUseCase: gh<_i397.RegisterUseCase>(),
        ));
    return this;
  }
}

class _$CoreModule extends _i573.CoreModule {}
