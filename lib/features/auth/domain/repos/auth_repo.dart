import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';

abstract class AuthRepo {
  Future<void> forgetPassword(String email);
  Future<void> verifyResetCode(String code);
  Future<void> resetPassword(ResetPasswordRequest request);
} 
