// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../features/app_sections/presentation/manager/app_section_cubit.dart'
    as _i959;
import '../../../features/auth/api/datasource/auth_remote_datasource_impl.dart'
    as _i777;
import '../../../features/auth/data/datasource/auth_remote_datasource.dart'
    as _i708;
import '../../../features/auth/data/repos/auth_repo_impl.dart' as _i566;
import '../../../features/auth/domain/repos/auth_repo.dart' as _i712;
import '../../../features/auth/domain/usecase/login_usecase.dart' as _i75;
import '../../../features/auth/presentation/login/manager/login_cubit.dart'
    as _i810;
import '../../core/api_manger/api_client.dart' as _i890;
import '../auth_storage/auth_storage.dart' as _i603;
import '../network/network_module.dart' as _i200;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.factory<_i959.AppSectionCubit>(() => _i959.AppSectionCubit());
    gh.lazySingleton<_i603.AuthStorage>(() => _i603.AuthStorage());
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i603.AuthStorage>()),
    );
    gh.lazySingleton<_i890.ApiClient>(
      () => networkModule.authApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i708.AuthRemoteDataSource>(
      () => _i777.AuthRemoteDataSourceImpl(gh<_i890.ApiClient>()),
    );
    gh.factory<_i712.AuthRepo>(
      () => _i566.AuthRepoImp(gh<_i708.AuthRemoteDataSource>()),
    );
    gh.factory<_i75.LoginUseCase>(
      () => _i75.LoginUseCase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i810.LoginCubit>(
      () => _i810.LoginCubit(gh<_i75.LoginUseCase>(), gh<_i603.AuthStorage>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
