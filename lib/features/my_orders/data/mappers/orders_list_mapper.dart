import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import '../models/order_model.dart';
import 'order_mapper.dart';

extension OrdersListMapper on List<Order> {
  List<OrderEntity> toEntityList() {
    return map((e) => e.toEntity()).toList();
  }
}
