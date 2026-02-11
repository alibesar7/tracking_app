import 'package:json_annotation/json_annotation.dart';

part 'apply_request_model.g.dart';

@JsonSerializable()
class ApplyRequestModel {
  final String? country;
  final String? firstName;
  final String? lastName;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense; // file path or url
  final String? nid;
  final String? nidImg;         // file path or url
  final String? email;
  final String? password;
  final String? rePassword;
  final String? gender;
  final String? phone;
   ApplyRequestModel({

     this.country, this.firstName, this.lastName, this.vehicleType, this.vehicleNumber, this.vehicleLicense, this.nid, this.nidImg, this.email, this.password, this.rePassword, this.gender, this.phone,
  });

  factory ApplyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ApplyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyRequestModelToJson(this);
}
