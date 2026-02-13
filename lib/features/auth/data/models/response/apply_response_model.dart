import 'package:json_annotation/json_annotation.dart';

part 'apply_response_model.g.dart';

@JsonSerializable()
class ApplyResponseModel {
  final String? message;
  final String? token;

  final String? country;
  final String? firstName;
  final String? lastName;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;

  @JsonKey(name: 'NID')
  final String? nid;

  @JsonKey(name: 'NIDImg')
  final String? nidImg;

  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;

  @JsonKey(name: '_id')
  final String? id;

  final DateTime? createdAt;

  ApplyResponseModel({
    this.message,
    this.token,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.id,
    this.createdAt,
  });

  factory ApplyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApplyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyResponseModelToJson(this);
}
