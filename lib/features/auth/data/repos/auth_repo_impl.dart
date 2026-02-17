import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import '../../domain/models/change_password_model.dart';
import '../../domain/repos/auth_repo.dart';
import '../datasource/auth_remote_datasource.dart';
import '../mapper/vehicles_mapper.dart';
import '../mappers/change_password_dto_mapper.dart';
import '../model/request/LoginRequest.dart';
import '../model/response/LoginResponse.dart';
import '../model/response/change_password_dto.dart';
import '../models/response/vehicle_model.dart';

@Injectable(as: AuthRepo)
class AuthRepoImp implements AuthRepo {
  final AuthRemoteDataSource authDatasource;
  AuthRepoImp(this.authDatasource);
  @override
  Future<ApiResult<LoginResponse>> login(String email, String password) async {
    final loginRequest = LoginRequest(email: email, password: password);
    final result = await authDatasource.login(loginRequest);
    if (result is SuccessApiResult<LoginResponse>) {
      return SuccessApiResult<LoginResponse>(data: result.data);
    }
    if (result is ErrorApiResult<LoginResponse>) {
      return ErrorApiResult<LoginResponse>(error: result.error);
    }
    return ErrorApiResult<LoginResponse>(error: 'Unknown error');
  }

  @override
  Future<ApiResult<ChangePasswordModel>> changePassword({
    required String token,
    String? password,
    String? newPassword,
  }) async {
    ApiResult<ChangePasswordDto> response = await authDatasource.changePassword(
      token: token,
      password: password,
      newPassword: newPassword,
    );
    switch (response) {
      case SuccessApiResult<ChangePasswordDto>():
        ChangePasswordDto dto = response.data;
        ChangePasswordModel changePassModel = dto.toChangePassModel();
        return SuccessApiResult<ChangePasswordModel>(data: changePassModel);
      case ErrorApiResult<ChangePasswordDto>():
        return ErrorApiResult<ChangePasswordModel>(error: response.error);
    }
  }

  @override
  Future<ApiResult<List<VehicleModel>>> getAllVehicles() async {
    final result = await authDatasource.getAllVehicle();
    switch (result) {
      case SuccessApiResult<VehiclesResponse>():
        return SuccessApiResult(
          data: result.data.vehicles.map((v) {
            return v.toVehicleType();
          }).toList(),
        );
      case ErrorApiResult<VehiclesResponse>():
        return ErrorApiResult(error: result.error);
    }
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
  Future<ApiResult<ApplyResponseModel>> apply(
    ApplyRequestModel applyRequestModel,
  ) async {
    final result = await authDatasource.apply(applyRequestModel);
    switch (result) {
      case SuccessApiResult<ApplyResponseModel>():
        return SuccessApiResult(data: result.data);
      case ErrorApiResult<ApplyResponseModel>():
        return ErrorApiResult(error: result.error);
    }
  }

  // @override
  // Future<ApiResult<SignupModel>> signup({
  //   String? firstName,
  //   String? lastName,
  //   String? email,
  //   String? password,
  //   String? rePassword,
  //   String? phone,
  //   String? gender,
  // }) async {
  //   ApiResult<SignupDto> signupResponse = await authDatasource.signUp(
  //     firstName: firstName,
  //     lastName: lastName,
  //     email: email,
  //     password: password,
  //     rePassword: rePassword,
  //     phone: phone,
  //     gender: gender,
  //   );
  //   switch (signupResponse) {
  //     case SuccessApiResult<SignupDto>():
  //       SignupDto dto = signupResponse.data;
  //       SignupModel signupModel = dto.toSignupModel();
  //       return SuccessApiResult<SignupModel>(data: signupModel);
  //     case ErrorApiResult<SignupDto>():
  //       return ErrorApiResult<SignupModel>(
  //         error: signupResponse.error.toString(),
  //       );
  //   }
  // }
}
