import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import 'order_details_states.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsStates> {
  final GetOrderDetailsUsecase getOrderDetailsUsecase;
  StreamSubscription? _subscription;

  OrderDetailsCubit(this.getOrderDetailsUsecase) : super(OrderDetailsStates());

  void getOrderDetails(String orderId) async {
    emit(state.copyWith(data: Resource.loading()));
    _subscription?.cancel();

    _subscription = getOrderDetailsUsecase
        .call(orderId)
        .listen(
          (order) {
            emit(state.copyWith(data: Resource.success(order)));
          },
          onError: (error) {
            emit(state.copyWith(data: Resource.error(error.toString())));
          },
        );
  }
}
