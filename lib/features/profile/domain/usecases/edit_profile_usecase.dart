import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/repo/profile_repo.dart';

class EditProfileUseCase {
  final ProfileRepo repository;

  EditProfileUseCase(this.repository);

  Future<ApiResult<EditProfileResponse>> call({
    required String token,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  }) async {
    return await repository.editProfile(
      token: token,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );
  }
}
