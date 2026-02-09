import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/models/change_password_dto.dart';

@Injectable(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  ApiClient apiClient;
  AuthRemoteDatasourceImpl(this.apiClient);
  @override
  Future<ApiResult<ChangePasswordDto>> changePassword({
    String? password,
    String? newPassword,
  }) {
    return safeApiCall<ChangePasswordDto>(
      call: () => apiClient.changePassword({
        "password": password,
        "newPassword": newPassword,
      }),
    );
  }
}
