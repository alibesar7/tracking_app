import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  @JsonKey(name: "_id")
  final String? Id;
  @JsonKey(name: "country")
  final String? country;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "vehicleType")
  final String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  final String? vehicleNumber;
  @JsonKey(name: "vehicleLicense")
  final String? vehicleLicense;
  @JsonKey(name: "NID")
  final String? NID;
  @JsonKey(name: "NIDImg")
  final String? NIDImg;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "createdAt")
  final String? createdAt;

  DriverModel({
    this.Id,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.NID,
    this.NIDImg,
    this.email,
    this.password,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return _$DriverModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverModelToJson(this);
  }

  static DriverModel fromEditProfileUser(DriverModel user) {
    return DriverModel(
      Id: user.Id,
      country: user.country,
      firstName: user.firstName,
      lastName: user.lastName,
      vehicleType: user.vehicleType,
      vehicleNumber: user.vehicleNumber,
      vehicleLicense: user.vehicleLicense,
      NID: user.NID,
      NIDImg: user.NIDImg,
      email: user.email,
      phone: user.phone,
      password: null,
    );
  }
}
