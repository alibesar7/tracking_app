import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

abstract class OrderDetailsRemoteDatasource {
  ApiResult<Stream<OrderDto>> getOrderStream(String orderId);
}
