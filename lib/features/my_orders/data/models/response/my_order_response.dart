import 'package:json_annotation/json_annotation.dart';
import '../meta_data_dto.dart';
import '../order_model.dart';

part 'my_order_response.g.dart';

@JsonSerializable()
class MyOrderResponse {
  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "metadata")
  final Metadata? metadata;

  @JsonKey(name: "orders")
  final List<Order>? orders;

  MyOrderResponse({this.message, this.metadata, this.orders});

  factory MyOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$MyOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrderResponseToJson(this);
}
