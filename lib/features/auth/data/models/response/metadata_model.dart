import 'package:json_annotation/json_annotation.dart';

part 'metadata_model.g.dart';

@JsonSerializable()
class Metadata {
  final int currentPage;
  final int totalPages;
  final int limit;
  final int totalItems;

  Metadata({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
    required this.totalItems,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
