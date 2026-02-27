import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

@Injectable(as: OrderDetailsRemoteDatasource)
class OrderDetailsRemoteDatasourceImpl implements OrderDetailsRemoteDatasource {
  final FirebaseFirestore _firestore;
  OrderDetailsRemoteDatasourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  ApiResult<Stream<OrderDto>> getOrderStream(String orderId) {
    try {
      final stream = _firestore
          .collection('orders')
          .doc(orderId)
          .snapshots()
          .map((snapshot) {
            if (!snapshot.exists || snapshot.data() == null) {
              throw Exception("Document does not exist!");
            }
            return OrderDto.fromJson(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            );
          });
      return SuccessApiResult<Stream<OrderDto>>(data: stream);
    } catch (e) {
      return ErrorApiResult<Stream<OrderDto>>(error: e.toString());
    }
  }
}
