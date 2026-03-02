// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../features/app_sections/presentation/manager/app_section_cubit.dart'
    as _i959;
import '../../../features/auth/api/datasource/auth_remote_datasource_impl.dart'
    as _i777;
import '../../../features/auth/data/datasource/auth_remote_datasource.dart'
    as _i708;
import '../../../features/auth/data/datasource/country_local_datasource.dart'
    as _i783;
import '../../../features/auth/data/repos/auth_repo_impl.dart' as _i566;
import '../../../features/auth/domain/repos/auth_repo.dart' as _i712;
import '../../../features/auth/domain/usecase/apply_usecase.dart' as _i412;
import '../../../features/auth/domain/usecase/change_password_usecase.dart'
    as _i991;
import '../../../features/auth/domain/usecase/forgetpassword_usecase.dart'
    as _i769;
import '../../../features/auth/domain/usecase/get_all_vehicles_usecase.dart'
    as _i1015;
import '../../../features/auth/domain/usecase/get_countries_usecase.dart'
    as _i940;
import '../../../features/auth/domain/usecase/login_usecase.dart' as _i75;
import '../../../features/auth/domain/usecase/resertpassword_usecase.dart'
    as _i294;
import '../../../features/auth/domain/usecase/verifyreaset_usecase.dart'
    as _i112;
import '../../../features/auth/presentation/apply/manager/apply_cubit.dart'
    as _i377;
import '../../../features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart'
    as _i614;
import '../../../features/auth/presentation/login/manager/login_cubit.dart'
    as _i810;
import '../../../features/auth/presentation/reset_password/manager/change_password_cubit.dart'
    as _i14;
import '../../../features/auth/presentation/reset_password/manager/reset_password_cubit.dart'
    as _i378;
import '../../../features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart'
    as _i466;
import '../../../features/track_order/api/track_order_remote_source_impl.dart'
    as _i1007;
import '../../../features/track_order/data/datasource/track_order_remote_source.dart'
    as _i511;
import '../../../features/track_order/data/repos/track_order_repo_imp.dart'
    as _i40;
import '../../../features/track_order/domain/repos/track_order_repo.dart'
    as _i1042;
import '../../../features/track_order/domain/usecases/driver_usecase.dart'
    as _i866;
import '../../../features/track_order/domain/usecases/track_order_usecase.dart'
    as _i810;
import '../../../features/track_order/domain/usecases/update_state_usecase.dart'
    as _i499;
import '../../../features/track_order/presentation/manager/cubit/track_order_cubit.dart'
    as _i364;
import '../../core/api_manger/api_client.dart' as _i890;
import '../../core/network/firebase_module.dart' as _i236;
import '../auth_storage/auth_storage.dart' as _i603;
import '../network/network_module.dart' as _i200;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i959.AppSectionCubit>(() => _i959.AppSectionCubit());
    gh.lazySingleton<_i603.AuthStorage>(() => _i603.AuthStorage());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.auth);
    gh.lazySingleton<_i783.CountryLocalDataSource>(
      () => _i783.CountryLocalDataSourceImpl(),
    );
    gh.factory<_i511.TrackOrderRemoteDataSource>(
      () =>
          _i1007.TrackOrderRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i603.AuthStorage>()),
    );
    gh.factory<_i1042.TrackOrderRepo>(
      () => _i40.TrackOrderRepoImpl(gh<_i511.TrackOrderRemoteDataSource>()),
    );
    gh.factory<_i866.TrackDriverUseCase>(
      () => _i866.TrackDriverUseCase(gh<_i1042.TrackOrderRepo>()),
    );
    gh.factory<_i810.TrackOrderUseCase>(
      () => _i810.TrackOrderUseCase(gh<_i1042.TrackOrderRepo>()),
    );
    gh.factory<_i499.UpdateOrderStatusUseCase>(
      () => _i499.UpdateOrderStatusUseCase(gh<_i1042.TrackOrderRepo>()),
    );
    gh.lazySingleton<_i890.ApiClient>(
      () => networkModule.authApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i364.TrackOrderCubit>(
      () => _i364.TrackOrderCubit(
        gh<_i810.TrackOrderUseCase>(),
        gh<_i866.TrackDriverUseCase>(),
        gh<_i499.UpdateOrderStatusUseCase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    gh.factory<_i708.AuthRemoteDataSource>(
      () => _i777.AuthRemoteDataSourceImpl(gh<_i890.ApiClient>()),
    );
    gh.factory<_i712.AuthRepo>(
      () => _i566.AuthRepoImpl(gh<_i708.AuthRemoteDataSource>()),
    );
    gh.factory<_i991.ChangePasswordUsecase>(
      () => _i991.ChangePasswordUsecase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i769.ForgetPasswordUsecase>(
      () => _i769.ForgetPasswordUsecase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i294.ResetPasswordUsecase>(
      () => _i294.ResetPasswordUsecase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i112.VerifyResetCodeUsecase>(
      () => _i112.VerifyResetCodeUsecase(gh<_i712.AuthRepo>()),
    );
    gh.factoryParam<_i466.VerifyResetCodeCubit, String, dynamic>(
      (email, _) => _i466.VerifyResetCodeCubit(
        gh<_i112.VerifyResetCodeUsecase>(),
        gh<_i769.ForgetPasswordUsecase>(),
        email,
      ),
    );
    gh.factoryParam<_i378.ResetPasswordCubit, String, dynamic>(
      (email, _) =>
          _i378.ResetPasswordCubit(email, gh<_i294.ResetPasswordUsecase>()),
    );
    gh.lazySingleton<_i412.ApplyUseCase>(
      () => _i412.ApplyUseCase(gh<_i712.AuthRepo>()),
    );
    gh.lazySingleton<_i1015.GetAllVehiclesUseCase>(
      () => _i1015.GetAllVehiclesUseCase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i940.GetCountriesUseCase>(
      () => _i940.GetCountriesUseCase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i75.LoginUseCase>(
      () => _i75.LoginUseCase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i14.ChangePasswordCubit>(
      () => _i14.ChangePasswordCubit(gh<_i991.ChangePasswordUsecase>()),
    );
    gh.factory<_i614.ForgetPasswordCubit>(
      () => _i614.ForgetPasswordCubit(
        gh<_i769.ForgetPasswordUsecase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    gh.factory<_i377.ApplyCubit>(
      () => _i377.ApplyCubit(
        gh<_i940.GetCountriesUseCase>(),
        gh<_i1015.GetAllVehiclesUseCase>(),
        gh<_i412.ApplyUseCase>(),
      ),
    );
    gh.factory<_i810.LoginCubit>(
      () => _i810.LoginCubit(gh<_i75.LoginUseCase>(), gh<_i603.AuthStorage>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i236.FirebaseModule {}

class _$NetworkModule extends _i200.NetworkModule {}
