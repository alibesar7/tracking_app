import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';

part 'edit_profile_response.g.dart';

@JsonSerializable()
class EditProfileResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "driver")
  final DriverModel? driver;

  EditProfileResponse({this.message, this.driver});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return _$EditProfileResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$EditProfileResponseToJson(this);
  }
}
