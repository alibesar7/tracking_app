import 'dart:io';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

class ProfileState {
  final Resource<EditProfileResponse> editProfileResource;
  final Resource<EditProfileResponse> uploadPhotoResource;
  final File? selectedPhoto;
  final DriverModel? driver;

  ProfileState({
    Resource<EditProfileResponse>? editProfileResource,
    Resource<EditProfileResponse>? uploadPhotoResource,
    this.selectedPhoto,
    this.driver,
  }) : editProfileResource = editProfileResource ?? Resource.initial(),
       uploadPhotoResource = uploadPhotoResource ?? Resource.initial();

  ProfileState copyWith({
    Resource<EditProfileResponse>? editProfileResource,
    Resource<EditProfileResponse>? uploadPhotoResource,
    File? selectedPhoto,
    bool clearSelectedPhoto = false,
    DriverModel? user,
  }) {
    return ProfileState(
      editProfileResource: editProfileResource ?? this.editProfileResource,
      uploadPhotoResource: uploadPhotoResource ?? this.uploadPhotoResource,
      selectedPhoto: clearSelectedPhoto
          ? null
          : (selectedPhoto ?? this.selectedPhoto),
      driver: user ?? this.driver,
    );
  }
}
