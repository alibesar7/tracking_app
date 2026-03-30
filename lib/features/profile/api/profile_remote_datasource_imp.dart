import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/profile/data/datasorce/profile_remote_datasource.dart';
import 'package:tracking_app/features/profile/data/models/requests/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

@Injectable(as: ProfileRemoteDatasource)
class ProfileRemoteDatasourceImp extends ProfileRemoteDatasource {
  final ApiClient apiClient;
  ProfileRemoteDatasourceImp(this.apiClient);

  @override
  Future<ApiResult<EditProfileResponse>> editProfile({
    required String token,
    EditProfileRequest? request,
  }) {
    return safeApiCall<EditProfileResponse>(
      call: () => apiClient.editProfile(token: token, request: request!),
    );
  }

  @override
  Future<ApiResult<EditProfileResponse>> uploadPhoto({
    required String token,
    required File photo,
  }) {
    return safeApiCall<EditProfileResponse>(
      call: () => apiClient.uploadPhoto(token: token, photo: photo),
    );
  }

  @override
  Future<ApiResult<EditProfileResponse>> getProfile({required String token}) {
    return safeApiCall<EditProfileResponse>(
      call: () => apiClient.getProfile(token: token),
    );
  }
}
