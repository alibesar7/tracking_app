import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

class GetOrderUseCase {
  final List<OrderEntity> orders;
  final MetadataEntity? metadata;

  GetOrderUseCase({required this.orders, required this.metadata});
}
