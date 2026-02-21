import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';

import '../models/order_item_model.dart';
import 'product_mapper.dart';

extension OrderItemMapper on OrderItem {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      product:
          product?.toEntity() ??
          ProductEntity(id: '', price: 0, title: '', image: ''),
      price: price ?? 0,
      quantity: quantity ?? 0,
    );
  }
}
