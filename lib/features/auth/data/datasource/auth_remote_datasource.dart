import 'package:tracking_app/features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';

import '../../../../app/core/network/api_result.dart';

abstract class AuthRemoteDataSource {

  Future<ApiResult<LogoutResponseDto>> logout();

}

