import 'package:tracking_app/features/track_order/domain/entities/order_location_entity.dart';

abstract class TrackOrderRepo {
  Stream<Order> trackOrder(String orderId);
}
