import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

abstract class OrderDetailsRemoteDatasource {
  ApiResult<Stream<OrderDto>> getOrderStream(String orderId);
  Future<ApiResult<void>> updateOrderState({
    required String orderId,
    required String state,
  });
  Future<ApiResult<void>> pushNotification({
    required String title,
    required String des,
  });
  Future<ApiResult<void>> sendDeviceNotification({
    required String userId,
    required String title,
    required String body,
  });
}
