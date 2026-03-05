import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/update_order_state_usecase.dart';

abstract class OrderDetailsRepo {
  ApiResult<Stream<OrderModel>> getOrderDetails(String orderId);
  Future<ApiResult<void>> updateOrderState(UpdateOrderStateParams params);
}
