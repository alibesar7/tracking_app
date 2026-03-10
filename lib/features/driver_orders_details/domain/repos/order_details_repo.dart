import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notficationDevice.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

abstract class OrderDetailsRepo {
  Future<ApiResult<Stream<OrderModel>>> getOrderDetails();
  ApiResult<Stream<DriverDataModel>> getDriverData(String driverId);

  Future<ApiResult<LatLng?>> getLatLngFromAddress(String address);

  Future<ApiResult<List<LatLng>>> getRealRoute(
    LatLng myLocation,
    LatLng destination,
  );
  Future<ApiResult<void>> updateOrderState(UpdateOrderStateParams params);
  Future<ApiResult<void>> pushNotification(PushNotificationParams params);
  Future<ApiResult<void>> sendDeviceNotification(
    SendDeviceNotificationParams params,
  );
}
