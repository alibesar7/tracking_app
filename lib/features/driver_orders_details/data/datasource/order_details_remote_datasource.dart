import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

abstract class OrderDetailsRemoteDatasource {
  ApiResult<Stream<OrderDto>> getOrderStream(String orderId);
  ApiResult<Stream<DriverDataDto>> getDriverData(String driverId);

  Future<ApiResult<LatLng?>> getLatLngFromAddress(String address);

  Future<ApiResult<List<LatLng>>> getRealRoute(
    LatLng myLocation,
    LatLng destination,
  );
}
