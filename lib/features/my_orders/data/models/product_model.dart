import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "price")
  final int? price;

  Product({this.id, this.price});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
