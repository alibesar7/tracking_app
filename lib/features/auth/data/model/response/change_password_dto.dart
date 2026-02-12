import 'package:json_annotation/json_annotation.dart';

part 'change_password_dto.g.dart';

@JsonSerializable()
class ChangePasswordDto {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'error')
  final String? error;
  @JsonKey(name: 'token')
  final String? token;

  ChangePasswordDto({this.message, this.error, this.token});

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordDtoToJson(this);
}
