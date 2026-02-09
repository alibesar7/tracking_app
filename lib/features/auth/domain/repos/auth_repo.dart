import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';

abstract class AuthRepo {
  Future<ApiResult<ChangePasswordModel>> changePassword({
    String? password,
    String? newPassword,
  });
}
