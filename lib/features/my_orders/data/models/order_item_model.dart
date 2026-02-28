import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItem {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "product")
  final Product? product;

  @JsonKey(name: "price")
  final int? price;

  @JsonKey(name: "quantity")
  final int? quantity;

  OrderItem({this.id, this.product, this.price, this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
