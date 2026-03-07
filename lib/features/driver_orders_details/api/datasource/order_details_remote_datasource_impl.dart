import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

@Injectable(as: OrderDetailsRemoteDatasource)
class OrderDetailsRemoteDatasourceImpl implements OrderDetailsRemoteDatasource {
  final FirebaseFirestore _firestore;
  final Dio dio;
  OrderDetailsRemoteDatasourceImpl({
    required FirebaseFirestore firestore,
    required this.dio,
  }) : _firestore = firestore;

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
      final response = await dio.get(
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
      final response = await dio.get(
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
}
