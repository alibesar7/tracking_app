import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@Injectable(as: TrackOrderRemoteDataSource)
class TrackOrderRemoteDataSourceImpl implements TrackOrderRemoteDataSource {
  final FirebaseFirestore firestore;

  TrackOrderRemoteDataSourceImpl(this.firestore);
  @override
  Stream<TrackOrderModel> trackOrder(String orderId) {
    return firestore.collection('orders').doc(orderId).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      if (data == null) {
        throw Exception("Order not found");
      }
      return TrackOrderModel.fromFirestore(snapshot.id, data);
    });
  }

  @override
  Stream<DriverModel> trackDriver(String driverId) {
    return firestore.collection('drivers').doc(driverId).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      if (data == null) throw Exception("Driver not found");
      return DriverModel.fromFirestore(snapshot.id, data);
    });
  }

  @override
  Future<DocumentSnapshot> updateOrderStatus(String orderId, String status) {
    return firestore
        .collection('orders')
        .doc(orderId)
        .update({'status': status})
        .then((_) {
          return firestore.collection('orders').doc(orderId).get();
        });
  }
}
