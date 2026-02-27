import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<void> loadUserData() async {
    final userJson = await _authStorage.getUserJson();

    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      //  final orderId = userMap['orderDetails']?['orderId'] as String?;
      final orderId = '696ae30ce364ef61404760df';
      if (orderId != null && orderId.isNotEmpty) {
        getOrderDetails(orderId);
      } else {
        debugPrint('Order ID not found in user data');
      }
    }
  }

  void getOrderDetails(String orderId) async {
    emit(state.copyWith(data: Resource.loading()));
    _subscription?.cancel();
    final result = _getOrderDetailsUsecase.call(orderId);

    switch (result) {
      case SuccessApiResult<Stream<OrderModel>>():
        _subscription = result.data.listen(
          (order) {
            emit(state.copyWith(data: Resource.success(order)));
          },
          onError: (error) {
            emit(state.copyWith(data: Resource.error(error.toString())));
          },
        );
      case ErrorApiResult<Stream<OrderModel>>(error: final errorMessage):
        emit(state.copyWith(data: Resource.error(errorMessage)));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
