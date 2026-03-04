import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/repo/profile_repo.dart';

@injectable
class UploadProfilePhotoUseCase {
  final ProfileRepo repository;

  UploadProfilePhotoUseCase(this.repository);

  Future<ApiResult<EditProfileResponse>> call({
    required String token,
    required File photo,
  }) async {
    return await repository.uploadPhoto(token: token, photo: photo);
  }
}
