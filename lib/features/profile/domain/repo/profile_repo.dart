import 'dart:io';

import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

abstract class ProfileRepo {
  Future<ApiResult<EditProfileResponse>> editProfile({
    required String token,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  });

  Future<ApiResult<EditProfileResponse>> uploadPhoto({
    required String token,
    required File photo,
  });

  Future<ApiResult<EditProfileResponse>> getProfile({required String token});
}
