import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/models/response/vechicles_entity.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';

import 'metadata_model.dart';

part 'vehicles_response_model.g.dart';

@JsonSerializable()
class VehiclesResponse {
  final String message;
  final Metadata metadata;
  final List<VehicleModel> vehicles;

  VehiclesResponse({
    required this.message,
    required this.metadata,
    required this.vehicles,
  });

  factory VehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$VehiclesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclesResponseToJson(this);
}
