import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;
  LoginUseCase(this._authRepo);

  Future<ApiResult<LoginResponse>> call(String email, String password) async {
    return await _authRepo.login(email, password);
  }
}
