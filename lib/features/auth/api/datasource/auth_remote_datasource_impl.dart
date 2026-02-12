import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:dio/dio.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ApiResult<LoginResponse>?> login(LoginRequest loginRequest) async {
    try {
      final response = await apiClient.login(loginRequest);
      return SuccessApiResult<LoginResponse>(data: response);
    } on DioException catch (e) {
      String errorMessage = 'unknownError';
      if (e.response?.statusCode == 401) {
        errorMessage = 'wrongEmailOrPassword';
      } else if (e.response != null && e.response?.data != null) {
        if (e.response!.data is Map<String, dynamic>) {
          errorMessage =
              e.response!.data['message'] ?? e.message ?? 'unknownError';
        } else {
          errorMessage = e.message ?? 'unknownError';
        }
      } else {
        errorMessage = e.message ?? 'unknownError';
      }
      return ErrorApiResult<LoginResponse>(error: errorMessage);
    } catch (e) {
      return ErrorApiResult<LoginResponse>(error: e.toString());
    }
  }

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
