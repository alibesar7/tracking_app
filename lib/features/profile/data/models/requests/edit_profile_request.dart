import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  @JsonKey(name: "firstName")
  final String? firstName;

  @JsonKey(name: "lastName")
  final String? lastName;

  @JsonKey(name: "email")
  final String? email;

  @JsonKey(name: "phone")
  final String? phone;

  @JsonKey(name: "vehicleType")
  final String? vehicleType;

  @JsonKey(name: "vehicleNumber")
  final String? vehicleNumber;

  @JsonKey(name: "vehicleLicense")
  final String? vehicleLicense;

  EditProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
  });

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
