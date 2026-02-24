import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';

abstract class TrackOrderRepo {
  Stream<OrderEntity> trackOrder(String orderId);
  Stream<DriverEntity> trackOrderWithDriver(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
}
