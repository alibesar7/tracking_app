import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TrackOrderRemoteDataSource {
  Stream<TrackOrderModel> trackOrder(String orderId);
  Stream<DriverModel> trackDriver(String driverId);
  Future<void> updateOrderStatus(String orderId, String status);
}

