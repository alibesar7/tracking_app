import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';

class OrderItemEntity {
  final ProductEntity product;
  final int price;
  final int quantity;

  OrderItemEntity({
    required this.product,
    required this.price,
    required this.quantity,
  });
}
