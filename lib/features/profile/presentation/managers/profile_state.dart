import 'dart:io';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

class ProfileState {
  final Resource<EditProfileResponse> editProfileResource;
  final Resource<EditProfileResponse> uploadPhotoResource;
  final File? selectedPhoto;

  ProfileState({
    Resource<EditProfileResponse>? editProfileResource,
    Resource<EditProfileResponse>? uploadPhotoResource,
    this.selectedPhoto,
  }) : editProfileResource = editProfileResource ?? Resource.initial(),
       uploadPhotoResource = uploadPhotoResource ?? Resource.initial();

  ProfileState copyWith({
    Resource<EditProfileResponse>? editProfileResource,
    Resource<EditProfileResponse>? uploadPhotoResource,
    File? selectedPhoto,
  }) {
    return ProfileState(
      editProfileResource: editProfileResource ?? this.editProfileResource,
      uploadPhotoResource: uploadPhotoResource ?? this.uploadPhotoResource,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
    );
  }
}
