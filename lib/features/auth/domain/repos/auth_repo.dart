import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';

abstract class AuthRepo {
  Future<ApiResult<ForgetPasswordEntitiy>> forgetPassword(String email);
  Future<ApiResult<VerifyResetCodeEntity>> verifyResetCode(String code);
  Future<ApiResult<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequest request,
  );

    Future<ApiResult<List<VehicleModel>>> getAllVehicles();
  Future<ApiResult<List<CountryEntity>>> getCountries();
  Future<ApiResult<ApplyResponseModel>> apply(
    ApplyRequestModel applyRequestModel,
  );
  Future<ApiResult<LoginResponse>> login(String email, String password);

  Future<ApiResult<ChangePasswordModel>> changePassword({
    String? password,
    String? newPassword,
  });
}

