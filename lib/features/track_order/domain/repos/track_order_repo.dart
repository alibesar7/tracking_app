import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
abstract class TrackOrderRepo {
  ApiResult<Stream<List<OrderEntity>>>  trackOrder(String orderId);
   ApiResult<Stream<DriverEntity>> trackOrderWithDriver(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
}
