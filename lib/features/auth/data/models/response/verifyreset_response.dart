import 'package:json_annotation/json_annotation.dart';

part 'verifyreset_response.g.dart';

@JsonSerializable()
class VerifyresetResponse {
    @JsonKey(name: "status")
    final String? status;

    VerifyresetResponse({
        this.status,
    });

    VerifyresetResponse copyWith({
        String? status,
    }) => 
        VerifyresetResponse(
            status: status ?? this.status,
        );

    factory VerifyresetResponse.fromJson(Map<String, dynamic> json) => _$VerifyresetResponseFromJson(json);

    Map<String, dynamic> toJson() => _$VerifyresetResponseToJson(this);
}
