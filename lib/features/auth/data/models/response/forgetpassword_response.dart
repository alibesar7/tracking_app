import 'package:json_annotation/json_annotation.dart';

part 'forgetpassword_response.g.dart';

@JsonSerializable()
class ForgetpasswordResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "info")
  final String? info;

  ForgetpasswordResponse({this.message, this.info});

  ForgetpasswordResponse copyWith({String? message, String? info}) =>
      ForgetpasswordResponse(
        message: message ?? this.message,
        info: info ?? this.info,
      );

  factory ForgetpasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetpasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetpasswordResponseToJson(this);
}
