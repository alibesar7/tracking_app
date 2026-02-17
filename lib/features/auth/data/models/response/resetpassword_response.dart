import 'package:json_annotation/json_annotation.dart';

part 'resetpassword_response.g.dart';

@JsonSerializable()
class ResetpasswordResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;

  ResetpasswordResponse({this.message, this.token});

  ResetpasswordResponse copyWith({String? message, String? token}) =>
      ResetpasswordResponse(
        message: message ?? this.message,
        token: token ?? this.token,
      );

  factory ResetpasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetpasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetpasswordResponseToJson(this);
}
