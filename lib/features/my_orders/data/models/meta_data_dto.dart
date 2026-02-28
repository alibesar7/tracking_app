import 'package:json_annotation/json_annotation.dart';

part 'meta_data_dto.g.dart';

@JsonSerializable()
class Metadata {
  @JsonKey(name: "currentPage")
  final int? currentPage;
  @JsonKey(name: "totalPages")
  final int? totalPages;
  @JsonKey(name: "totalItems")
  final int? totalItems;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "cancelledCount")
  final int? cancelledCount;
  @JsonKey(name: "completedCount")
  final int? completedCount;

  Metadata({
    this.currentPage,
    this.totalPages,
    required this.totalItems,
    required this.limit,
    this.cancelledCount = 0,
    this.completedCount = 0,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return _$MetadataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MetadataToJson(this);
  }
}
