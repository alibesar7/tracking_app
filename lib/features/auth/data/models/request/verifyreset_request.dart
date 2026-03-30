import 'package:json_annotation/json_annotation.dart';
part 'verifyreset_request.g.dart';

@JsonSerializable()
class VerifyResetRequest {
  final String resetCode;
  VerifyResetRequest({required this.resetCode});
  factory VerifyResetRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyResetRequestToJson(this);
}
