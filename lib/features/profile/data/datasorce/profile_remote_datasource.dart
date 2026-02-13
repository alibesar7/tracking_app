import 'dart:io';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/requests/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

abstract class ProfileRemoteDatasource {
  Future<ApiResult<EditProfileResponse>> editProfile({
    required String token,
    EditProfileRequest? request,
  });

  Future<ApiResult<EditProfileResponse>> getProfile({required String token});

  Future<ApiResult<EditProfileResponse>> uploadPhoto({
    required String token,
    required File photo,
  });
}
