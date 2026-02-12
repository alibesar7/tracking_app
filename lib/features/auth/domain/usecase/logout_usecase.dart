import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';

import '../../../../app/core/network/api_result.dart';
import '../repos/auth_repo.dart';

@injectable
class LogoutUseCase {
  final AuthRepo _authRepo;
  LogoutUseCase(this._authRepo);
  Future<ApiResult<LogoutResponseDto>> call() async {
    return await _authRepo.logout();
  }
}
