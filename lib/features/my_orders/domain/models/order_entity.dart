import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/store_entity.dart';

class OrderEntity {
  final String id;
  final UserEntity user;
  final StoreEntity? store;
  final String address;
  final List<OrderItemEntity> items;
  final int totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final String createdAt;
  final String orderNumber;

  OrderEntity({
    required this.id,
    required this.user,
    this.store,
    this.address = '',
    required this.items,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.createdAt,
    required this.orderNumber,
  });
}
