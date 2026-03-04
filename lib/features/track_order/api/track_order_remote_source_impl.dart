import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@Injectable(as: TrackOrderRemoteDataSource)
class TrackOrderRemoteDataSourceImpl implements TrackOrderRemoteDataSource {
  final FirebaseFirestore firestore;
  final AuthStorage authStorage;
  TrackOrderRemoteDataSourceImpl(this.firestore, this.authStorage);
  @override
  ApiResult<Stream<List<TrackOrderModel>>> trackOrder(String userId) {
    try {
      final stream = firestore
          .collection('orders')
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => TrackOrderModel.fromFirestore(doc.id, doc.data()))
                .toList();
          });
      return SuccessApiResult<Stream<List<TrackOrderModel>>>(data: stream);
    } catch (e) {
      return ErrorApiResult<Stream<List<TrackOrderModel>>>(error: e.toString());
    }
  }

  @override
  ApiResult<Stream<DriverModel>> trackDriver(String driverId) {
    try {
      final stream = firestore
          .collection('drivers')
          .doc(driverId)
          .snapshots()
          .map((snapshot) {
            final data = snapshot.data();
            if (data == null) throw Exception("Driver not found");
            return DriverModel.fromFirestore(snapshot.id, data);
          });
      return SuccessApiResult<Stream<DriverModel>>(data: stream);
    } catch (e) {
      return ErrorApiResult<Stream<DriverModel>>(error: e.toString());
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      // 1. Fetch current order data to get deviceToken
      final orderDoc = await firestore.collection('orders').doc(orderId).get();
      final orderData = orderDoc.data();
      final deviceToken = orderData?['deviceToken'] ?? '';

      // 2. Update order status
      await firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 3. Add notification
      await firestore.collection('notification').add({
        'title': 'Order Status Updated',
        'description': 'Order $orderId status changed to $status',
        'orderId': orderId,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'targetApp': 'flower_shop',
        'deviceToken': deviceToken,
      });

      return orderDoc;
    } catch (e) {
      rethrow;
    }
  }
}
