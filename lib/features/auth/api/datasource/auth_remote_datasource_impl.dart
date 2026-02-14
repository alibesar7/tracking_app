import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';

@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  ApiClient apiClient;
  AuthRemoteDatasourceImpl(this.apiClient);
  @override
  Future<ApiResult<ForgetpasswordResponse>?> forgetPassword(
    ForgetPasswordRequest request,
  ) {
    return safeApiCall(call: () => apiClient.forgetPassword(request));
  }

  @override
  Future<ApiResult<VerifyresetResponse>?> verifyResetCode(
    VerifyResetRequest request,
  ) {
    return safeApiCall(call: () => apiClient.verifyResetCode(request));
  }

  @override
  Future<ApiResult<ResetpasswordResponse>?> resetPassword(
    ResetPasswordRequest request,
  ) {
    return safeApiCall(call: () => apiClient.resetPassword(request));
  }
}
