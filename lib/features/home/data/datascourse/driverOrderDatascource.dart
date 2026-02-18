import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';

abstract class DriverOrderDataSource {
  Future<ApiResult<OrderResponse>> getPendingOrders(String token);
}
