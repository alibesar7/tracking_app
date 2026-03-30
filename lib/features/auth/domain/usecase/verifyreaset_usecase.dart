import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class VerifyResetCodeUsecase {
  AuthRepo authRepo;
  VerifyResetCodeUsecase(this.authRepo);
  Future<ApiResult<VerifyResetCodeEntity>> call(String code) {
    return authRepo.verifyResetCode(code);
  }
}
