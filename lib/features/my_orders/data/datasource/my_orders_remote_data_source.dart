import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/data/models/response/my_order_response.dart';

abstract class MyOrdersRemoteDataSource {
  Future<ApiResult<MyOrderResponse>> getAllOrders({
    required String token,
    int limit = 10,
    int page = 1,
  });
}
