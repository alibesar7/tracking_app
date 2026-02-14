import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  AuthRemoteDatasource remoteDatasource;
  AuthRepoImpl(this.remoteDatasource);

  Future<ApiResult<ForgetPasswordEntitiy>> forgetPassword(String email) async {
    final result = await remoteDatasource.forgetPassword(
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
      return ErrorApiResult<ForgetPasswordEntitiy>(error: result.error);
    }
    ;
    return ErrorApiResult<ForgetPasswordEntitiy>(error: 'Unexpected error');
  }

  @override
  Future<ApiResult<VerifyResetCodeEntity>> verifyResetCode(String code) async {
    final result = await remoteDatasource.verifyResetCode(
      VerifyResetRequest(resetCode: code),
    );

    if (result is SuccessApiResult<VerifyresetResponse>) {
      return SuccessApiResult(
        data: VerifyResetCodeEntity(status: result.data.status),
      );
    }

    if (result is ErrorApiResult<VerifyresetResponse>) {
      return ErrorApiResult<VerifyResetCodeEntity>(error: result.error);
    }

    return ErrorApiResult<VerifyResetCodeEntity>(error: 'Unexpected error');
  }

  @override
  Future<ApiResult<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final result = await remoteDatasource.resetPassword(request);

    if (result is SuccessApiResult<ResetpasswordResponse>) {
      return SuccessApiResult(
        data: ResetPasswordEntity(
          token: result.data.token,
          message: result.data.message,
        ),
      );
    }

    if (result is ErrorApiResult<ResetpasswordResponse>) {
      return ErrorApiResult<ResetPasswordEntity>(error: result.error);
    }

    return ErrorApiResult<ResetPasswordEntity>(error: 'Unexpected error');
  }
}
