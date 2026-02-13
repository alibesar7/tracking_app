import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/models/response/vechicles_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  @JsonKey(name:'_id')
  final String? id;
  final String ?type;
  final String? image;
  final DateTime ?createdAt;
  final DateTime ?updatedAt;

  @JsonKey(name: '__v')
  final int? version;

  VehicleModel({
   this.id,
   this.type,
   this.image,
   this.createdAt,
   this.updatedAt,
   this.version,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

}
