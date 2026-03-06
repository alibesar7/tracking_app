import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

abstract class OrderDetailsRepo {
  ApiResult<Stream<OrderModel>> getOrderDetails(String orderId);
  Future<ApiResult<void>> updateOrderState(UpdateOrderStateParams params);
  Future<ApiResult<void>> pushNotification(PushNotificationParams params);
}
