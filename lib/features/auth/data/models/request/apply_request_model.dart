import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'apply_request_model.g.dart';

@JsonSerializable()
class ApplyRequestModel {
  final String? country;
  final String? firstName;
  final String? lastName;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? NID;
  final String? email;
  final String? password;
  final String? rePassword;
  final String? gender;
  final String? phone;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? vehicleLicense;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? NIDimg;

  const ApplyRequestModel({
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.NID,
    this.NIDimg,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.phone,
  });

  factory ApplyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ApplyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyRequestModelToJson(this);
}
