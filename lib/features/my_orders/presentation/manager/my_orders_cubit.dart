import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/domain/usecases/get_order_use_case.dart';

import 'my_orders_intent.dart';
import 'my_orders_state.dart';

@injectable
class MyOrdersCubit extends Cubit<MyOrdersState> {
  final GetOrderUseCase _getOrdersUseCase;
  final AuthStorage _authStorage;

  int _page = 1;
  bool _hasMore = true;

  MyOrdersCubit(this._getOrdersUseCase, this._authStorage)
    : super(MyOrdersState());

  void doIntent(MyOrdersIntent intent) {
    switch (intent.runtimeType) {
      case GetMyOrdersIntent:
        _getOrders(intent as GetMyOrdersIntent);
        break;

      case LoadMoreOrdersIntent:
        _loadMore();
        break;

      case OpenOrderDetailsIntent:
        emit(
          state.copyWith(
            selectedOrder: (intent as OpenOrderDetailsIntent).order,
          ),
        );
        break;

      case FilterCompletedOrdersIntent:
        _filterCompleted();
        break;

      case FilterCancelledOrdersIntent:
        _filterCancelled();
        break;
    }
  }

  Future<void> _getOrders(GetMyOrdersIntent intent) async {
    emit(state.copyWith(ordersResource: Resource.loading()));

    final token = await _authStorage.getToken();
    if (token == null || token.isEmpty) {
      emit(state.copyWith(ordersResource: Resource.error("Token not found")));
      return;
    }
    _hasMore = true;

    final result = await _getOrdersUseCase.call(
      token: 'Bearer $token',
      page: intent.page,
      limit: intent.limit,
    );

    if (isClosed) return;
    switch (result) {
      case SuccessApiResult():
        final data = result.data;
        _hasMore = data.metadata != null && _page < data.metadata!.totalPages;

        emit(
          state.copyWith(
            orders: data.orders,
            metadata: data.metadata,
            ordersResource: Resource.success(data),
          ),
        );
        break;

      case ErrorApiResult():
        emit(state.copyWith(ordersResource: Resource.error(result.error)));
        break;
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final token = await _authStorage.getToken();
    if (token == null || token.isEmpty) {
      emit(state.copyWith(isLoadingMore: false));
      return;
    }

    _page++;

    final result = await _getOrdersUseCase.call(
      token: 'Bearer $token',
      page: _page,
    );

    if (isClosed) return;

    switch (result) {
      case SuccessApiResult():
        emit(
          state.copyWith(
            orders: [...state.orders, ...result.data.orders],
            metadata: result.data.metadata,
            isLoadingMore: false,
          ),
        );
        break;

      case ErrorApiResult():
        emit(state.copyWith(isLoadingMore: false));
        break;
    }
  }

  void _filterCompleted() {
    final filtered = state.orders.where((e) => e.isDelivered == true).toList();

    emit(state.copyWith(orders: filtered));
  }

  void _filterCancelled() {
    final filtered = state.orders.where((e) => e.state == 'cancelled').toList();
    emit(state.copyWith(orders: filtered));
  }
}
