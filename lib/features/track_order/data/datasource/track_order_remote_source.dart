import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';

abstract class TrackOrderRemoteDataSource {
  Stream<OrderModel> trackOrder(String orderId);
}
