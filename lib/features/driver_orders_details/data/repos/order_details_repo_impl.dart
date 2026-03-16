import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/drivers_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/order_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notficationDevice.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final OrderDetailsRemoteDatasource _remoteDataSource;
  final AuthStorage _authStorage;
  OrderDetailsRepoImpl(this._remoteDataSource, this._authStorage);

  @override
  Future<ApiResult<Stream<OrderModel>>> getOrderDetails() async {
    final orderId = await _authStorage.getOrderId();
    if (orderId == null) {
      return ErrorApiResult<Stream<OrderModel>>(error: "No order ID found");
    }
    final result = _remoteDataSource.getOrderStream(orderId);

    switch (result) {
      case SuccessApiResult<Stream<OrderDto>>():
        return SuccessApiResult<Stream<OrderModel>>(
          data: result.data.map((dto) => dto.toOrderModel()),
        );
      case ErrorApiResult<Stream<OrderDto>>():
        return ErrorApiResult<Stream<OrderModel>>(error: result.error);
    }
  }

  @override
  ApiResult<Stream<DriverDataModel>> getDriverData(String driverId) {
    final result = _remoteDataSource.getDriverData(driverId);

    switch (result) {
      case SuccessApiResult<Stream<DriverDataDto>>():
        return SuccessApiResult<Stream<DriverDataModel>>(
          data: result.data.map((dto) => dto.toDriversModel()),
        );
      case ErrorApiResult<Stream<DriverDataDto>>():
        return ErrorApiResult<Stream<DriverDataModel>>(error: result.error);
    }
  }

  @override
  Future<ApiResult<LatLng?>> getLatLngFromAddress(String address) {
    return _remoteDataSource.getLatLngFromAddress(address);
  }

  @override
  Future<ApiResult<List<LatLng>>> getRealRoute(
    LatLng myLocation,
    LatLng destination,
  ) {
    return _remoteDataSource.getRealRoute(myLocation, destination);
  }

  Future<ApiResult<void>> updateOrderState(
    UpdateOrderStateParams params,
  ) async {
    return _remoteDataSource.updateOrderState(
      orderId: params.orderId,
      state: params.state,
    );
  }

  @override
  Future<ApiResult<void>> pushNotification(
    PushNotificationParams params,
  ) async {
    return _remoteDataSource.pushNotification(
      title: params.title,
      des: params.des,
    );
  }

  @override
  Future<ApiResult<void>> sendDeviceNotification(
    SendDeviceNotificationParams params,
  ) async {
    return _remoteDataSource.sendDeviceNotification(
      userId: params.userId,
      title: params.title,
      body: params.body,
    );
  }

  @override
  Future<void> updateDriverLocation(
    String driverId,
    double lat,
    double lng,
  ) async {
    return _remoteDataSource.updateDriverLocation(driverId, lat, lng);
  }
}
