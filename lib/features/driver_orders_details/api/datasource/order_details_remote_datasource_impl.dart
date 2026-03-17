import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

@Injectable(as: OrderDetailsRemoteDatasource)
class OrderDetailsRemoteDatasourceImpl implements OrderDetailsRemoteDatasource {
  final FirebaseFirestore _firestore;
  final Dio _dio;
  OrderDetailsRemoteDatasourceImpl({
    required FirebaseFirestore firestore,
    required Dio dio,
  }) : _dio = dio,
       _firestore = firestore;

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
  ApiResult<Stream<DriverDataDto>> getDriverData(String driverId) {
    try {
      final stream = _firestore
          .collection('drivers')
          .doc(driverId)
          .snapshots()
          .where((snapshot) => snapshot.exists && snapshot.data() != null)
          .map((snapshot) {
            return DriverDataDto.fromJson(
              snapshot.data() as Map<String, dynamic>,
            );
          });
      return SuccessApiResult<Stream<DriverDataDto>>(data: stream);
    } catch (e) {
      return ErrorApiResult<Stream<DriverDataDto>>(error: e.toString());
    }
  }

  @override
  Future<ApiResult<LatLng?>> getLatLngFromAddress(String address) async {
    try {
      final response = await _dio.get(
        "https://nominatim.openstreetmap.org/search",
        queryParameters: {
          "q": "$address, Egypt",
          "format": "json",
          "limit": 1,
          "addressdetails": 1,
        },
        options: Options(headers: {"User-Agent": "tracking_app"}),
      );

      final data = response.data;

      print("<<<<<<<< Geocode response: $data");

      if (response.statusCode == 200 && data != null && data.isNotEmpty) {
        double lat = double.parse(data[0]['lat']);
        double lon = double.parse(data[0]['lon']);

        return SuccessApiResult<LatLng?>(data: LatLng(lat, lon));
      }
      return SuccessApiResult<LatLng?>(data: null);
    } catch (e) {
      return ErrorApiResult<LatLng?>(error: e.toString());
    }
  }

  @override
  Future<ApiResult<List<LatLng>>> getRealRoute(
    LatLng myLocation,
    LatLng destination,
  ) async {
    try {
      final response = await _dio.get(
        "https://router.project-osrm.org/route/v1/driving/"
        "${myLocation.longitude},${myLocation.latitude};"
        "${destination.longitude},${destination.latitude}",
        queryParameters: {"overview": "full", "geometries": "polyline"},
      );

      final data = response.data;

      if (response.statusCode == 200 && data['code'] == 'Ok') {
        String encodedPolyline = data['routes'][0]['geometry'];

        List<PointLatLng> result = PolylinePoints.decodePolyline(
          encodedPolyline,
        );

        List<LatLng> polylineCoordinates = result
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        return SuccessApiResult<List<LatLng>>(data: polylineCoordinates);
      }

      return ErrorApiResult<List<LatLng>>(error: 'No route found');
    } catch (e) {
      return ErrorApiResult<List<LatLng>>(error: e.toString());
    }
  }

  @override
  Future<void> updateDriverLocation(
    String driverId,
    double lat,
    double lng,
  ) async {
    await FirebaseFirestore.instance.collection('drivers').doc(driverId).update(
      {"currentLocation.lat": lat, "currentLocation.lng": lng},
    );
  }

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

      // 2. Send FCM push notification via HTTP v1 API
      // Using service account credentials to generate an OAuth2 token
      final String jsonString = await rootBundle.loadString(
        'assets/data/elevate-flower-app-8c49aaa82a83.json',
      );
      final credentials = ServiceAccountCredentials.fromJson(jsonString);
      final client = await clientViaServiceAccount(credentials, [
        'https://www.googleapis.com/auth/firebase.messaging',
      ]);
      final String oauthToken = client.credentials.accessToken.data;
      client.close();

      final response = await _dio.post(
        'https://fcm.googleapis.com/v1/projects/elevate-flower-app/messages:send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $oauthToken',
          },
        ),
        data: {
          'message': {
            'token': deviceToken,
            'notification': {'title': title, 'body': body},
            'android': {
              'notification': {
                'sound': 'default',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              },
            },
            'apns': {
              'payload': {
                'aps': {
                  'sound': 'default',
                  'category': 'FLUTTER_NOTIFICATION_CLICK',
                },
              },
            },
          },
        },
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to user mvc');
        return SuccessApiResult<void>(data: null);
      } else {
        return ErrorApiResult<void>(
          error: 'FCM error: \${response.statusCode}',
        );
      }
    } catch (e) {
      return ErrorApiResult<void>(error: e.toString());
    }
  }

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
