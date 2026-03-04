import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

class MyOrdersResult {
  final List<OrderEntity> orders;
  final MetadataEntity? metadata;

  MyOrdersResult({required this.orders, this.metadata});
}

abstract class MyOrdersRepo {
  Future<ApiResult<MyOrdersResult>> getAllOrders({
    required String token,
    int limit,
    int page,
  });
}
