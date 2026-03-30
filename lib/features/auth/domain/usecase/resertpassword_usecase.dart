import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class ResetPasswordUsecase {
  AuthRepo authRepo;
  ResetPasswordUsecase(this.authRepo);
  Future<ApiResult<ResetPasswordEntity>> call(ResetPasswordRequest request) {
    return authRepo.resetPassword(request);
  }
}
