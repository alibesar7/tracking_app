import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';

abstract class AuthRemoteDatasource {
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
