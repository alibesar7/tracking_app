import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<LoginResponse>?> login(LoginRequest loginRequest);

  Future<ApiResult<ChangePasswordDto>> changePassword({
    String? password,
    String? newPassword,
  });
}
