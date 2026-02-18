import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' hide Order;
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/domain/usecase/getdriverOrderUsecase.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderIntent.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderStates.dart';

@injectable
class DriverOrderCubit extends Cubit<DriverOrderState> {
  final GetDriverOrdersUseCase _getDriverOrdersUseCase;
  final AuthStorage _authStorage;

  DriverOrderCubit(this._getDriverOrdersUseCase, this._authStorage)
    : super(DriverOrderState());

  void onIntent(DriverOrderIntent intent) {
    switch (intent) {
      case GetPendingOrders():
        _getPendingOrders();
      case RemoveOrder(order: final order):
        _removeOrder(order);
    }
  }

  void _removeOrder(Order order) {
    final currentResource = state.orderResource;
    if (currentResource.status == Status.success &&
        currentResource.data != null) {
      final currentOrders = currentResource.data!.orders!;
      final updatedOrders = currentOrders
          .where((element) => element != order)
          .toList();
      emit(
        state.copyWith(
          orderResource: Resource.success(
            currentResource.data!.copyWith(orders: updatedOrders),
          ),
        ),
      );
    }
  }

  Future<void> _getPendingOrders() async {
    emit(state.copyWith(orderResource: Resource.loading()));
    final token = await _authStorage.getToken();
    if (token == null) {
      emit(
        state.copyWith(orderResource: Resource.error("User not authenticated")),
      );
      return;
    }
    final result = await _getDriverOrdersUseCase(token);
    return switch (result) {
      SuccessApiResult(data: final orderResponse) => emit(
        state.copyWith(orderResource: Resource.success(orderResponse)),
      ),
      ErrorApiResult(error: final error) => emit(
        state.copyWith(orderResource: Resource.error(error)),
      ),
    };
  }
}
