import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackOrderRemoteDataSourceImpl implements TrackOrderRemoteDataSource {
  final FirebaseFirestore firestore;

  TrackOrderRemoteDataSourceImpl(this.firestore);

  @override
  Stream<OrderModel> trackOrder(String orderId) {
    return firestore
        .collection('u8sj29sk2sff') 
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          return OrderModel.fromFirestore(data!);
        });
  }
}
