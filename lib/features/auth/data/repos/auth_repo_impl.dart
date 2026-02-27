import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/mapper/vehicles_mapper.dart';
import 'package:tracking_app/features/auth/data/mappers/change_password_dto_mapper.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authDatasource;

  AuthRepoImpl(this.authDatasource);

  @override
  Future<ApiResult<ForgetPasswordEntitiy>> forgetPassword(String email) async {
    final result = await authDatasource.forgetPassword(
      ForgetPasswordRequest(email: email),
    );

    if (result is SuccessApiResult<ForgetpasswordResponse>) {
      return SuccessApiResult(
        data: ForgetPasswordEntitiy(
          message: result.data.message,
          info: result.data.info,
        ),
      );
    }

    if (result is ErrorApiResult<ForgetpasswordResponse>) {
      return ErrorApiResult(error: result.error);
    }

    return ErrorApiResult(error: 'Unexpected error');
  }

  @override
  Future<ApiResult<VerifyResetCodeEntity>> verifyResetCode(String code) async {
    final result = await authDatasource.verifyResetCode(
      VerifyResetRequest(resetCode: code),
    );

    if (result is SuccessApiResult<VerifyresetResponse>) {
      return SuccessApiResult(
        data: VerifyResetCodeEntity(status: result.data.status),
      );
    }

    if (result is ErrorApiResult<VerifyresetResponse>) {
      return ErrorApiResult(error: result.error);
    }

    return ErrorApiResult(error: 'Unexpected error');
  }

  @override
  Future<ApiResult<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final result = await authDatasource.resetPassword(request);

    if (result is SuccessApiResult<ResetpasswordResponse>) {
      return SuccessApiResult(
        data: ResetPasswordEntity(
          token: result.data.token,
          message: result.data.message,
        ),
      );
    }

    if (result is ErrorApiResult<ResetpasswordResponse>) {
      return ErrorApiResult(error: result.error);
    }

    return ErrorApiResult(error: 'Unexpected error');
  }

  @override
  Future<ApiResult<LoginResponse>> login(String email, String password) async {
    final loginRequest = LoginRequest(email: email, password: password);
    final result = await authDatasource.login(loginRequest);

    if (result is SuccessApiResult<LoginResponse>) {
      return SuccessApiResult(data: result.data);
    }

    if (result is ErrorApiResult<LoginResponse>) {
      return ErrorApiResult(error: result.error);
    }

    return ErrorApiResult(error: 'Unknown error');
  }

  @override
  Future<ApiResult<ChangePasswordModel>> changePassword({
    String? password,
    String? newPassword,
  }) async {
    final response = await authDatasource.changePassword(
      password: password,
      newPassword: newPassword,
    );

    if (response is SuccessApiResult<ChangePasswordDto>) {
      final dto = response.data;
      return SuccessApiResult(data: dto.toChangePassModel());
    }

    if (response is ErrorApiResult<ChangePasswordDto>) {
      return ErrorApiResult(error: response.error);
    }

    return ErrorApiResult(error: 'Unknown error');
  }

  @override
  Future<ApiResult<List<VehicleModel>>> getAllVehicles() async {
    final result = await authDatasource.getAllVehicle();

    if (result is SuccessApiResult<VehiclesResponse>) {
      return SuccessApiResult(
        data: result.data.vehicles.map((v) => v.toVehicleType()).toList(),
      );
    }

    if (result is ErrorApiResult<VehiclesResponse>) {
      return ErrorApiResult(error: result.error);
    }

    return ErrorApiResult(error: 'Unknown error');
  }

  @override
  Future<ApiResult<List<CountryEntity>>> getCountries() async {
    try {
      final response = await authDatasource.getCountries();
      return SuccessApiResult(data: response);
    } catch (error) {
      return ErrorApiResult(error: error.toString());
    }
  }

  @override
  Future<ApiResult<ApplyResponseModel>> apply(ApplyRequestModel request) async {
    final result = await authDatasource.apply(request);

    if (result is SuccessApiResult<ApplyResponseModel>) {
      return SuccessApiResult(data: result.data);
    }

    if (result is ErrorApiResult<ApplyResponseModel>) {
      return ErrorApiResult(error: result.error);
    }

    return ErrorApiResult(error: 'Unknown error');
  }
}
