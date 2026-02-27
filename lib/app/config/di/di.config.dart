// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
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
import '../../../features/auth/domain/usecase/logout_usecase.dart' as _i27;
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
import '../../../features/auth/presentation/logout/manager/logout_cubit.dart'
    as _i1023;
import '../../../features/auth/presentation/reset_password/manager/change_password_cubit.dart'
    as _i14;
import '../../../features/auth/presentation/reset_password/manager/reset_password_cubit.dart'
    as _i378;
import '../../../features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart'
    as _i466;
import '../../../features/home/api/driverOrderDataS_imp.dart' as _i495;
import '../../../features/home/data/datascourse/driverOrderDatascource.dart'
    as _i743;
import '../../../features/home/data/repo/driverOrderRepo_impl.dart' as _i1020;
import '../../../features/home/domain/repo/driverOrderRepo.dart' as _i499;
import '../../../features/home/domain/usecase/getdriverOrderUsecase.dart'
    as _i858;
import '../../../features/home/domain/usecase/upload_driver_fire_data_use_case.dart'
    as _i329;
import '../../../features/home/domain/usecase/upload_order_fire_data_use_case.dart'
    as _i233;
import '../../../features/home/presentation/manger/driverorderCubit.dart'
    as _i573;
import '../../../features/my_orders/api/datasource/my_orders_remote_data_source_imp.dart'
    as _i583;
import '../../../features/my_orders/data/datasource/my_orders_remote_data_source.dart'
    as _i466;
import '../../../features/my_orders/data/repo/my_orders_repo_imp.dart' as _i754;
import '../../../features/my_orders/domain/repo/my_orders_repo.dart' as _i919;
import '../../../features/my_orders/domain/usecases/get_order_use_case.dart'
    as _i335;
import '../../../features/my_orders/presentation/manager/my_orders_cubit.dart'
    as _i156;
import '../../../features/profile/api/profile_lacal_datasource_imp.dart'
    as _i495;
import '../../../features/profile/api/profile_remote_datasource_imp.dart'
    as _i899;
import '../../../features/profile/data/datasorce/profile_lacal_datasource.dart'
    as _i697;
import '../../../features/profile/data/datasorce/profile_remote_datasource.dart'
    as _i943;
import '../../../features/profile/data/repo/profile_repo_imp.dart' as _i1048;
import '../../../features/profile/domain/repo/profile_repo.dart' as _i863;
import '../../../features/profile/domain/usecases/edit_profile_usecase.dart'
    as _i221;
import '../../../features/profile/domain/usecases/get_profile_usecase.dart'
    as _i248;
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
    gh.factory<_i959.AppSectionCubit>(() => _i959.AppSectionCubit());
    gh.lazySingleton<_i603.AuthStorage>(() => _i603.AuthStorage());
    gh.lazySingleton<_i783.CountryLocalDataSource>(
      () => _i783.CountryLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => networkModule.firestore,
      instanceName: 'firestore',
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i603.AuthStorage>()),
    );
    gh.factory<_i329.UploadDriverFireDataUseCase>(
      () => _i329.UploadDriverFireDataUseCase(
        gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
      ),
    );
    gh.factory<_i233.UploadOrderFireDataUseCase>(
      () => _i233.UploadOrderFireDataUseCase(
        gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
      ),
    );
    gh.lazySingleton<_i697.ProfileLocalDataSource>(
      () => _i495.ProfileLocalDataSourceImpl(gh<_i603.AuthStorage>()),
    );
    gh.lazySingleton<_i890.ApiClient>(
      () => networkModule.authApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i466.MyOrdersRemoteDataSource>(
      () => _i583.MyOrdersRemoteDataSourceImp(gh<_i890.ApiClient>()),
    );
    gh.factory<_i919.MyOrdersRepo>(
      () => _i754.MyOrdersRepoImpl(gh<_i466.MyOrdersRemoteDataSource>()),
    );
    gh.factory<_i335.GetOrderUseCase>(
      () => _i335.GetOrderUseCase(gh<_i919.MyOrdersRepo>()),
    );
    gh.factory<_i743.DriverOrderDataSource>(
      () => _i495.DriverOrderDataSourceImpl(gh<_i890.ApiClient>()),
    );
    gh.factory<_i943.ProfileRemoteDatasource>(
      () => _i899.ProfileRemoteDatasourceImp(gh<_i890.ApiClient>()),
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
    gh.factory<_i156.MyOrdersCubit>(
      () => _i156.MyOrdersCubit(
        gh<_i335.GetOrderUseCase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    gh.factoryParam<_i378.ResetPasswordCubit, String, dynamic>(
      (email, _) =>
          _i378.ResetPasswordCubit(email, gh<_i294.ResetPasswordUsecase>()),
    );
    gh.factory<_i499.DriverOrderRepo>(
      () => _i1020.DriverOrderRepositoryImpl(gh<_i743.DriverOrderDataSource>()),
    );
    gh.factory<_i863.ProfileRepo>(
      () => _i1048.ProfileRepoImpl(
        gh<_i943.ProfileRemoteDatasource>(),
        gh<_i697.ProfileLocalDataSource>(),
      ),
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
    gh.factory<_i27.LogoutUseCase>(
      () => _i27.LogoutUseCase(gh<_i712.AuthRepo>()),
    );
    gh.factory<_i14.ChangePasswordCubit>(
      () => _i14.ChangePasswordCubit(
        gh<_i991.ChangePasswordUsecase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    gh.factory<_i614.ForgetPasswordCubit>(
      () => _i614.ForgetPasswordCubit(
        gh<_i769.ForgetPasswordUsecase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    gh.factory<_i858.GetDriverOrdersUseCase>(
      () => _i858.GetDriverOrdersUseCase(gh<_i499.DriverOrderRepo>()),
    );
    gh.factory<_i377.ApplyCubit>(
      () => _i377.ApplyCubit(
        gh<_i940.GetCountriesUseCase>(),
        gh<_i1015.GetAllVehiclesUseCase>(),
        gh<_i412.ApplyUseCase>(),
      ),
    );
    gh.factory<_i221.EditProfileUseCase>(
      () => _i221.EditProfileUseCase(gh<_i863.ProfileRepo>()),
    );
    gh.factory<_i248.GetProfileUsecase>(
      () => _i248.GetProfileUsecase(gh<_i863.ProfileRepo>()),
    );
    gh.factory<_i884.UploadProfilePhotoUseCase>(
      () => _i884.UploadProfilePhotoUseCase(gh<_i863.ProfileRepo>()),
    );
    gh.factory<_i1023.LogoutCubit>(
      () =>
          _i1023.LogoutCubit(gh<_i27.LogoutUseCase>(), gh<_i603.AuthStorage>()),
    );
    gh.factory<_i810.LoginCubit>(
      () => _i810.LoginCubit(gh<_i75.LoginUseCase>(), gh<_i603.AuthStorage>()),
    );
    gh.factory<_i573.DriverOrderCubit>(
      () => _i573.DriverOrderCubit(
        gh<_i858.GetDriverOrdersUseCase>(),
        gh<_i603.AuthStorage>(),
        gh<_i329.UploadDriverFireDataUseCase>(),
        gh<_i233.UploadOrderFireDataUseCase>(),
        gh<_i499.DriverOrderRepo>(),
      ),
    );
    gh.factory<_i603.ProfileCubit>(
      () => _i603.ProfileCubit(
        gh<_i221.EditProfileUseCase>(),
        gh<_i884.UploadProfilePhotoUseCase>(),
        gh<_i248.GetProfileUsecase>(),
        gh<_i603.AuthStorage>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
