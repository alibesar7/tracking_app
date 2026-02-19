import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

import '../models/order_model.dart';
import 'order_item_mapper.dart';
import 'user_mapper.dart';

extension OrderMapper on Order {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? '',
      user: user!.toEntity(),
      items: orderItems?.map((e) => e.toEntity()).toList() ?? [],
      totalPrice: totalPrice ?? 0,
      paymentType: paymentType ?? '',
      isPaid: isPaid ?? false,
      isDelivered: isDelivered ?? false,
      state: state ?? '',
      createdAt: createdAt ?? '',
      orderNumber: orderNumber ?? '',
    );
  }
}
