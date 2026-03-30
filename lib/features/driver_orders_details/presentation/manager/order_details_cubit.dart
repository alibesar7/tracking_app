import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_driver_data_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_address_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notficationDevice.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_real_route_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/push_notification_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/send_device_notification_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/update_driver_location_usecase.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_state_usecase.dart';
import 'order_details_intents.dart';
import 'order_details_states.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsStates> {
  final GetOrderDetailsUsecase _getOrderDetailsUsecase;
  final GetDriverDataUsecase _getDriverDataUsecase;
  final UpdateOrderStateUsecase _updateOrderStateUsecase;
  final PushNotificationUsecase _pushNotificationUsecase;
  final SendDeviceNotificationUsecase _sendDeviceNotificationUsecase;
  final GetAddressUsecase _getAddressUsecase;
  final GetRealRouteUsecase _getRealRouteUsecase;
  final UpdateDriverLocationUsecase _updateDriverLocationUsecase;
  StreamSubscription? _orderSubscription;
  StreamSubscription? _driverSubscription;
  Timer? _driverMoveTimer;
  int _currentIndex = 0;
  List<LatLng> _fullRoute = [];

  OrderDetailsCubit(
    this._getOrderDetailsUsecase,
    this._getDriverDataUsecase,
    this._getAddressUsecase,
    this._getRealRouteUsecase,
    this._updateDriverLocationUsecase,
    this._updateOrderStateUsecase,
    this._pushNotificationUsecase,
    this._sendDeviceNotificationUsecase,
  ) : super(OrderDetailsStates());

  final _authStorage = getIt<AuthStorage>();

  void onIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case GetOrderDetails():
        getOrderDetails();
      case UpdateOrderState(currentStatus: final status):
        _updateOrderState(status);
    }
  }

  void getOrderDetails() async {
    emit(state.copyWith(data: Resource.loading()));
    _orderSubscription?.cancel();

    final result = await _getOrderDetailsUsecase.call();

    if (result is SuccessApiResult<Stream<OrderModel>>) {
      _orderSubscription = result.data.listen(
        (order) {
          emit(state.copyWith(data: Resource.success(order)));
          if (order.driverId.isNotEmpty) {
            getDriverData(order.driverId);
          }
        },
        onError: (error) {
          emit(state.copyWith(data: Resource.error(error.toString())));
        },
      );
    } else if (result is ErrorApiResult<Stream<OrderModel>>) {
      emit(state.copyWith(data: Resource.error(result.error)));
    }
  }

  void getDriverData(String driverId) async {
    emit(state.copyWith(driverData: Resource.loading()));
    _driverSubscription?.cancel();
    final result = _getDriverDataUsecase.call(driverId);
    if (result is SuccessApiResult<Stream<DriverDataModel>>) {
      _driverSubscription = result.data.listen((driver) async {
        emit(state.copyWith(driverData: Resource.success(driver)));
      });
    } else if (result is ErrorApiResult<Stream<DriverDataModel>>) {
      emit(state.copyWith(driverData: Resource.error(result.error)));
    }
  }

  Future<void> getRoute(LatLng driverLocation) async {
    if (state.destination == null) return;

    final result = await _getRealRouteUsecase.getRealRoute(
      driverLocation,
      state.destination!,
    );

    if (result is SuccessApiResult<List<LatLng>>) {
      _fullRoute = result.data;
      _currentIndex = 0;
      emit(state.copyWith(polylines: _fullRoute));
    }
  }

  Future<void> setDestinationFromAddress(
    String address,
    LatLng driverLocation,
  ) async {
    if (state.destination != null) return;

    final result = await _getAddressUsecase.getAddress(address);

    if (result is SuccessApiResult<LatLng?> && result.data != null) {
      emit(state.copyWith(destination: result.data));
      await getRoute(driverLocation);
      startDriverSimulation();
    }
  }

  LatLng moveTowards(LatLng current, LatLng destination, double step) {
    double latDiff = destination.latitude - current.latitude;
    double lngDiff = destination.longitude - current.longitude;

    double newLat = current.latitude + (latDiff * step);
    double newLng = current.longitude + (lngDiff * step);

    return LatLng(newLat, newLng);
  }

  void startDriverSimulation() {
    _driverMoveTimer?.cancel();
    _driverMoveTimer = Timer.periodic(const Duration(seconds: 10), (
      timer,
    ) async {
      final driver = state.driverData?.data;

      if (driver == null || _fullRoute.isEmpty) return;

      if (_currentIndex >= _fullRoute.length) {
        timer.cancel();
        return;
      }

      final nextPoint = _fullRoute[_currentIndex];
      _currentIndex++;

      await _updateDriverLocationUsecase.updateDriverLocation(
        driver.id,
        nextPoint.latitude,
        nextPoint.longitude,
      );
      final remainingRoute = _fullRoute.sublist(_currentIndex);

      emit(state.copyWith(polylines: remainingRoute));
    });
  }

  String? _nextStateFor(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
      case 'accepted':
        return 'Picked';
      case 'picked':
        return 'Out for delivery';
      case 'out for delivery':
        return 'Arrived';
      case 'arrived':
        return 'Delivered';
      default:
        return null;
    }
  }

  Future<void> _updateOrderState(String currentStatus) async {
    final orderId = await _authStorage.getOrderId();
    if (orderId == null || orderId.isEmpty) return;

    final nextState = _nextStateFor(currentStatus);
    if (nextState == null) return;

    final result = await _updateOrderStateUsecase(
      UpdateOrderStateParams(orderId: orderId, state: nextState),
    );

    if (result is SuccessApiResult<void>) {
      final title = 'Order Update';
      final body = 'Your order is now $nextState';

      await _pushNotificationUsecase(
        PushNotificationParams(title: title, des: body),
      );

      // Send actual FCM push to device token
      if (state.data?.data?.userId != null) {
        await _sendDeviceNotificationUsecase(
          SendDeviceNotificationParams(
            userId: state.data!.data!.userId,
            title: title,
            body: body,
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    _driverSubscription?.cancel();
    _driverMoveTimer?.cancel();
    return super.close();
  }
}
