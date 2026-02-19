import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';

class OrderEntity {
  final String id;
  final UserEntity user;
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
