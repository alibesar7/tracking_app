import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TrackOrderRemoteDataSource {
  ApiResult<Stream<List<TrackOrderModel>>> trackOrder(String userId);
  ApiResult<Stream<DriverModel>> trackDriver(String driverId);
  Future<DocumentSnapshot<Map<String, dynamic>>> updateOrderStatus(String orderId, String status);
}
