import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/datasorce/profile_remote_datasource.dart';
import 'package:tracking_app/features/profile/data/models/requests/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/repo/profile_repo.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDatasource profileDatasource;

  ProfileRepoImpl(this.profileDatasource);

  @override
  Future<ApiResult<EditProfileResponse>> editProfile({
    required String token,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  }) async {
    try {
      final result = await profileDatasource.editProfile(
        token: token,
        request: EditProfileRequest(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          vehicleType: vehicleType,
          vehicleNumber: vehicleNumber,
          vehicleLicense: vehicleLicense,
        ),
      );

      if (result is SuccessApiResult<EditProfileResponse>) {
        return SuccessApiResult<EditProfileResponse>(data: result.data);
      } else if (result is ErrorApiResult<EditProfileResponse>) {
        return ErrorApiResult<EditProfileResponse>(error: result.error);
      } else {
        return ErrorApiResult<EditProfileResponse>(error: 'Unknown error');
      }
    } catch (e) {
      return ErrorApiResult<EditProfileResponse>(error: e.toString());
    }
  }

  @override
  Future<ApiResult<EditProfileResponse>> uploadPhoto({
    required String token,
    required File photo,
  }) async {
    try {
      final result = await profileDatasource.uploadPhoto(
        token: token,
        photo: photo,
      );

      if (result is SuccessApiResult<EditProfileResponse>) {
        return SuccessApiResult<EditProfileResponse>(data: result.data);
      } else if (result is ErrorApiResult<EditProfileResponse>) {
        return ErrorApiResult<EditProfileResponse>(error: result.error);
      } else {
        return ErrorApiResult<EditProfileResponse>(error: 'Unknown error');
      }
    } catch (e) {
      return ErrorApiResult<EditProfileResponse>(error: e.toString());
    }
  }
}
