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
import '../../domain/usecases/get_order_details_usecase.dart';
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
  ) : super(OrderDetailsStates());

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

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    _driverSubscription?.cancel();
    return super.close();
  }
}
