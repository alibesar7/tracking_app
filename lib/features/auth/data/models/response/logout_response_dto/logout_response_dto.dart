import 'package:json_annotation/json_annotation.dart';

part 'logout_response_dto.g.dart';

@JsonSerializable()
class LogoutResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "error")
  final String? error;

  LogoutResponseDto({this.message, this.error});

  factory LogoutResponseDto.fromJson(Map<String, dynamic> json) {
    return _$LogoutResponseDtoFromJson(json);
  }
}
