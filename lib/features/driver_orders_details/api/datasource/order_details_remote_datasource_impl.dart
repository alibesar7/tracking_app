import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/values/api_constants.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

@Injectable(as: OrderDetailsRemoteDatasource)
class OrderDetailsRemoteDatasourceImpl implements OrderDetailsRemoteDatasource {
  final FirebaseFirestore _firestore;
  final Dio _dio;

  OrderDetailsRemoteDatasourceImpl({
    required FirebaseFirestore firestore,
    required Dio dio,
  }) : _firestore = firestore,
       _dio = dio;

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

  @override
  Future<ApiResult<void>> pushNotification({
    required String title,
    required String des,
  }) async {
    try {
      await _firestore.collection('notification').add({
        'title': title,
        'des': des,
      });
      return SuccessApiResult<void>(data: null);
    } catch (e) {
      return ErrorApiResult<void>(error: e.toString());
    }
  }

  @override
  Future<ApiResult<void>> sendDeviceNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      // 1. Get the user document from the u8sj29sk2k collection using id_user
      final querySnapshot = await _firestore
          .collection('u8sj29sk2k')
          .where('id_user', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return ErrorApiResult<void>(error: 'User not found');
      }

      final userDoc = querySnapshot.docs.first;
      final deviceToken = userDoc.data()['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        return ErrorApiResult<void>(error: 'Device token not found');
      }

      // 2. Send FCM push notification via legacy HTTP API
      final response = await _dio.post(
        'https://fcm.googleapis.com/fcm/send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=${ApiConstants.fcmServerKey}',
          },
        ),
        data: {
          'to': deviceToken,
          'notification': {'title': title, 'body': body, 'sound': 'default'},
          'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
        },
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to user mvc');
        return SuccessApiResult<void>(data: null);
      } else {
        return ErrorApiResult<void>(error: 'FCM error: ${response.statusCode}');
      }
    } catch (e) {
      return ErrorApiResult<void>(error: e.toString());
    }
  }
}
