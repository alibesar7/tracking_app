import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/change_password_dto.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResult<ChangePasswordDto>> changePassword({
    String? password,
    String? newPassword,
  });
}
