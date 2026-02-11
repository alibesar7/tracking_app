import 'dart:io';

sealed class ProfileIntent {}

class PerformEditProfile extends ProfileIntent {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;

  PerformEditProfile({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
  });
}

class SelectPhotoIntent extends ProfileIntent {
  final File photo;
  SelectPhotoIntent(this.photo);
}

class UploadSelectedPhotoIntent extends ProfileIntent {
  final String token;
  UploadSelectedPhotoIntent(this.token);
}
