import 'package:cloud_firestore/cloud_firestore.dart';

abstract class OrderDetailsRemoteDatasource {
  Stream<DocumentSnapshot> getOrderStream(String orderId);
}
