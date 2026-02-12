import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';

import '../../../../app/core/network/api_result.dart';
import '../../domain/repos/auth_repo.dart';
import '../datasource/auth_remote_datasource.dart';

@Injectable(as: AuthRepo)
class AuthRepoImp implements AuthRepo {
  final AuthRemoteDataSource authDatasource;
  AuthRepoImp(this.authDatasource);


  @override
  Future<ApiResult<LogoutResponseDto>> logout() async {
    final result = await authDatasource.logout();
    if (result is SuccessApiResult<LogoutResponseDto>) {
      return SuccessApiResult<LogoutResponseDto>(data: result.data);
    }
    if (result is ErrorApiResult<LogoutResponseDto>) {
      return ErrorApiResult<LogoutResponseDto>(error: result.error);
    }
    return ErrorApiResult<LogoutResponseDto>(error: 'Unexpected error');
  }


}

