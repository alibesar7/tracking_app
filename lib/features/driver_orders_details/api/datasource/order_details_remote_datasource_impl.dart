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
          .where((snapshot) => snapshot.exists && snapshot.data() != null)
          .map((snapshot) {
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

  @override
  Future<ApiResult<void>> updateOrderState({
    required String orderId,
    required String state,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('orderId', isEqualTo: orderId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'oder_dt.status': state,
        });
      } else {
        await _firestore.collection('orders').doc(orderId).update({
          'oder_dt.status': state,
        });
      }
      return SuccessApiResult<void>(data: null);
    } catch (e) {
      return ErrorApiResult<void>(error: e.toString());
    }
  }
}
