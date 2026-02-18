import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@Injectable(as: OrderDetailsRemoteDatasource)
class OrderDetailsRemoteDatasourceImpl implements OrderDetailsRemoteDatasource {
  final FirebaseFirestore firestore;
  OrderDetailsRemoteDatasourceImpl({required this.firestore});

  @override
  Stream<DocumentSnapshot> getOrderStream(String orderId) {
    return firestore.collection('u8sj29sk2sff').doc(orderId).snapshots();
  }
}
