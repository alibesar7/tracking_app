import 'package:json_annotation/json_annotation.dart';
import 'order_item_model.dart';
import 'user_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class Order {
  @JsonKey(name: "_id")
  final String? id;

  @JsonKey(name: "user")
  final User? user;

  @JsonKey(name: "orderItems")
  final List<OrderItem>? orderItems;

  @JsonKey(name: "totalPrice")
  final int? totalPrice;

  @JsonKey(name: "paymentType")
  final String? paymentType;

  @JsonKey(name: "isPaid")
  final bool? isPaid;

  @JsonKey(name: "isDelivered")
  final bool? isDelivered;

  @JsonKey(name: "state")
  final String? state;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  @JsonKey(name: "updatedAt")
  final String? updatedAt;

  @JsonKey(name: "orderNumber")
  final String? orderNumber;

  @JsonKey(name: "__v")
  final int? v;

  Order({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
