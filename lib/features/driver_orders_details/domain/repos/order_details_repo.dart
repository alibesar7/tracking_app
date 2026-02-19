import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

abstract class OrderDetailsRepo {
  ApiResult<Stream<OrderModel>> getOrderDetails(String orderId);
}
