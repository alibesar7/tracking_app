import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';
import '../../../../app/core/network/api_result.dart';
import '../models/response/country_model.dart';
import '../models/response/vehicles_response_model.dart';
import '../models/request/apply_request_model.dart';
import '../models/response/apply_response_model.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<VehiclesResponse>> getAllVehicle();
  Future<ApiResult<ApplyResponseModel>> apply(
    ApplyRequestModel applyRequestModel,
  );
  Future<List<CountryModel>> getCountries();

  Future<ApiResult<LoginResponse>?> login(LoginRequest loginRequest);

  Future<ApiResult<ChangePasswordDto>> changePassword({
    String? password,
    String? newPassword,
  });
  Future<ApiResult<ForgetpasswordResponse>?> forgetPassword(
    ForgetPasswordRequest request,
  );
  Future<ApiResult<VerifyresetResponse>?> verifyResetCode(
    VerifyResetRequest request,
  );
  Future<ApiResult<ResetpasswordResponse>?> resetPassword(
    ResetPasswordRequest request,
  );
}

