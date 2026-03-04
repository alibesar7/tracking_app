import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import 'order_details_states.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsStates> {
  final GetOrderDetailsUsecase _getOrderDetailsUsecase;
  StreamSubscription? _subscription;
  final _authStorage = getIt<AuthStorage>();

  OrderDetailsCubit(this._getOrderDetailsUsecase) : super(OrderDetailsStates());

  void getOrderDetails() async {
    emit(state.copyWith(data: Resource.loading()));
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
          (order) {
            emit(state.copyWith(data: Resource.success(order)));
          },
          onError: (error) {
            emit(state.copyWith(data: Resource.error(error.toString())));
          },
        );
      } else if (result is ErrorApiResult<Stream<OrderModel>>) {
        emit(state.copyWith(data: Resource.error(result.error)));
      }
    } catch (e) {
      emit(
        state.copyWith(
          data: Resource.error("Error retrieving order details: $e"),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
