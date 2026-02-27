import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class ForgetPasswordUsecase {
  AuthRepo authRepo;
  ForgetPasswordUsecase(this.authRepo);
  Future<ApiResult<ForgetPasswordEntitiy>> call(String email) {
    return authRepo.forgetPassword(email);
  }
}
