import 'package:json_annotation/json_annotation.dart';
part 'LoginResponse.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "token")
  String? token;

  LoginResponse({this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
