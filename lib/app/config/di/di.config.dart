// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../features/profile/api/profile_remote_datasource_imp.dart'
    as _i899;
import '../../../features/profile/data/datasorce/profile_remote_datasource.dart'
    as _i943;
import '../../../features/profile/domain/usecases/edit_profile_usecase.dart'
    as _i221;
import '../../../features/profile/domain/usecases/upload_profile_photo_usecase.dart'
    as _i884;
import '../../../features/profile/presentation/managers/profile_cubit.dart'
    as _i603;
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
    gh.lazySingleton<_i603.AuthStorage>(() => _i603.AuthStorage());
    gh.factory<_i603.ProfileCubit>(
      () => _i603.ProfileCubit(
        gh<_i221.EditProfileUseCase>(),
        gh<_i884.UploadProfilePhotoUseCase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i603.AuthStorage>()),
    );
    gh.lazySingleton<_i890.ApiClient>(
      () => networkModule.authApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i943.ProfileRemoteDatasource>(
      () => _i899.ProfileRemoteDatasourceImp(gh<_i890.ApiClient>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
