import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class ChangePasswordUsecase {
  AuthRepo authRepo;
  ChangePasswordUsecase(this.authRepo);
  Future<ApiResult<ChangePasswordModel>> call({
    required String token,
    String? password,
    String? newPassword,
  }) {
    return authRepo.changePassword(
      token: token,
      password: password,
      newPassword: newPassword,
    );
  }
}
