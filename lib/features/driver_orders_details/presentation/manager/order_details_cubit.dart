import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_driver_data_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/location_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notficationDevice.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/push_notification_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/send_device_notification_usecase.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_state_usecase.dart';
import 'order_details_intents.dart';
import 'order_details_states.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsStates> {
  final GetOrderDetailsUsecase _getOrderDetailsUsecase;
  final GetDriverDataUsecase _getDriverDataUsecase;
  final LocationUsecase _locationUsecase;
  StreamSubscription? _orderSubscription;
  StreamSubscription? _driverSubscription;

  OrderDetailsCubit(
    this._getOrderDetailsUsecase,
    this._getDriverDataUsecase,
    this._locationUsecase,
  final UpdateOrderStateUsecase _updateOrderStateUsecase;
  final PushNotificationUsecase _pushNotificationUsecase;
  final SendDeviceNotificationUsecase _sendDeviceNotificationUsecase;
  StreamSubscription? _subscription;
  final _authStorage = getIt<AuthStorage>();

  OrderDetailsCubit(
    this._getOrderDetailsUsecase,
    this._updateOrderStateUsecase,
    this._pushNotificationUsecase,
    this._sendDeviceNotificationUsecase,
  ) : super(OrderDetailsStates());

  void onIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case GetOrderDetails():
        _getOrderDetails();
      case UpdateOrderState(currentStatus: final status):
        _updateOrderState(status);
    }
  }

  void _getOrderDetails() async {
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
    _subscription?.cancel();

    try {
      final orderId = await _authStorage.getOrderId();
      if (orderId == null || orderId.isEmpty) {
        emit(state.copyWith(data: Resource.error('Order ID not found')));
        return;
      }

      final result = _getOrderDetailsUsecase.call(orderId);

      if (result is SuccessApiResult<Stream<OrderModel>>) {
        _subscription = result.data.listen(
          (order) => emit(state.copyWith(data: Resource.success(order))),
          onError: (error) =>
              emit(state.copyWith(data: Resource.error(error.toString()))),
        );
      } else if (result is ErrorApiResult<Stream<OrderModel>>) {
        emit(state.copyWith(data: Resource.error(result.error)));
      }
    } catch (e) {
      emit(
        state.copyWith(
          data: Resource.error('Error retrieving order details: $e'),
        ),
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

  Future<void> setDestinationFromAddress(
    String address,
    LatLng driverLocation,
  ) async {
    final result = await _locationUsecase.getAddress(address);
    if (result is SuccessApiResult<LatLng?> && result.data != null) {
      emit(state.copyWith(destination: result.data));
      await getRoute(driverLocation);
    }
  }

  Future<void> getRoute(LatLng driverLocation) async {
    if (state.destination == null) return;

    final result = await _locationUsecase.getRealRoute(
      driverLocation,
      state.destination!,
    );
    if (result is SuccessApiResult<List<LatLng>>) {
      emit(state.copyWith(polylines: result.data));
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

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    _driverSubscription?.cancel();
    return super.close();
  }
}
