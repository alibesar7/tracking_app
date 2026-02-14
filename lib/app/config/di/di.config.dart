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

import '../../../features/auth/api/datasource/auth_remote_datasource_impl.dart'
    as _i777;
import '../../../features/auth/data/datasource/auth_remote_datasource.dart'
    as _i708;
import '../../../features/auth/data/repos/auth_repo_impl.dart' as _i566;
import '../../../features/auth/domain/repos/auth_repo.dart' as _i712;
import '../../../features/auth/domain/usecase/forgetpassword_usecase.dart'
    as _i769;
import '../../../features/auth/domain/usecase/resertpassword_usecase.dart'
    as _i294;
import '../../../features/auth/domain/usecase/verifyreaset_usecase.dart'
    as _i112;
import '../../../features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart'
    as _i614;
import '../../../features/auth/presentation/reset_password/manager/reset_password_cubit.dart'
    as _i378;
import '../../../features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart'
    as _i466;
import '../../core/api_manger/api_client.dart' as _i890;
import '../auth_storage/auth_storage.dart' as _i603;
import '../network/network_module.dart' as _i200;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i603.AuthStorage>(() => _i603.AuthStorage());
    gh.lazySingleton<_i361.Dio>(
        () => networkModule.dio(gh<_i603.AuthStorage>()));
    gh.lazySingleton<_i890.ApiClient>(
        () => networkModule.authApiClient(gh<_i361.Dio>()));
    gh.factory<_i708.AuthRemoteDatasource>(
        () => _i777.AuthRemoteDatasourceImpl(gh<_i890.ApiClient>()));
    gh.factory<_i712.AuthRepo>(
        () => _i566.AuthRepoImpl(gh<_i708.AuthRemoteDatasource>()));
    gh.factory<_i769.ForgetPasswordUsecase>(
        () => _i769.ForgetPasswordUsecase(gh<_i712.AuthRepo>()));
    gh.factory<_i294.ResetPasswordUsecase>(
        () => _i294.ResetPasswordUsecase(gh<_i712.AuthRepo>()));
    gh.factory<_i112.VerifyResetCodeUsecase>(
        () => _i112.VerifyResetCodeUsecase(gh<_i712.AuthRepo>()));
    gh.factoryParam<_i466.VerifyResetCodeCubit, String, dynamic>((
      email,
      _,
    ) =>
        _i466.VerifyResetCodeCubit(
          gh<_i112.VerifyResetCodeUsecase>(),
          gh<_i769.ForgetPasswordUsecase>(),
          email,
        ));
    gh.factoryParam<_i378.ResetPasswordCubit, String, dynamic>((
      email,
      _,
    ) =>
        _i378.ResetPasswordCubit(
          email,
          gh<_i294.ResetPasswordUsecase>(),
        ));
    gh.factory<_i614.ForgetPasswordCubit>(() => _i614.ForgetPasswordCubit(
          gh<_i769.ForgetPasswordUsecase>(),
          gh<_i603.AuthStorage>(),
        ));
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
