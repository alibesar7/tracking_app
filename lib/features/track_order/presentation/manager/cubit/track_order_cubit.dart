import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/track_order_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/driver_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'track_order_state.dart';

@injectable
class TrackOrderCubit extends Cubit<TrackOrderState> {
  final FirebaseFirestore firestore;

  final TrackOrderUseCase trackOrderUseCase;
  final TrackDriverUseCase driverUseCase;

  StreamSubscription<OrderEntity>? _orderSubscription;
  StreamSubscription<DriverEntity>? _driverSubscription;

  TrackOrderCubit(this.firestore, this.trackOrderUseCase, this.driverUseCase)
    : super(const TrackOrderState());

  void trackOrder(String orderId) {
    emit(state.copyWith(isLoading: true, error: null));

    _orderSubscription?.cancel();
    _driverSubscription?.cancel();

    /// -------- ORDER --------
    final orderResult = trackOrderUseCase(orderId);

    if (orderResult is SuccessApiResult<Stream<OrderEntity>>) {
      _orderSubscription = orderResult.data.listen(
        (order) {
          emit(state.copyWith(order: order, isLoading: false, error: null));
        },
        onError: (error) {
          emit(state.copyWith(error: error.toString(), isLoading: false));
        },
      );
    } else if (orderResult is ErrorApiResult<Stream<OrderEntity>>) {
      emit(state.copyWith(error: orderResult.error, isLoading: false));
    }

    /// -------- DRIVER --------
    final driverResult = driverUseCase(orderId);

    if (driverResult is SuccessApiResult<Stream<DriverEntity>>) {
      _driverSubscription = driverResult.data.listen(
        (driver) {
          emit(state.copyWith(driver: driver, error: null));
        },
        onError: (error) {
          emit(state.copyWith(error: error.toString(), isLoading: false));
        },
      );
    } else if (driverResult is ErrorApiResult<Stream<DriverEntity>>) {
      emit(state.copyWith(error: driverResult.error, isLoading: false));
    }
  }

  @override
  Future<void> close() async {
    await _orderSubscription?.cancel();
    await _driverSubscription?.cancel();
    return super.close();
  }
}
