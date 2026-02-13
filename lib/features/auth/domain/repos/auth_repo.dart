import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';

abstract class AuthRepo {
  Future<ApiResult<ForgetpasswordEntitiy>> forgetPassword(String email);
  Future<ApiResult<VerifyResetCodeEntity>> verifyResetCode(String code);
  Future<ApiResult<ResetPasswordEntity>> resetPassword(ResetPasswordRequest request);
} 
