import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

class MyOrdersState {
  final Resource<void> ordersResource;
  final List<OrderEntity> orders;
  final MetadataEntity? metadata;
  final OrderEntity? selectedOrder;
  final bool isLoadingMore;

  MyOrdersState({
    Resource<void>? ordersResource,
    this.orders = const [],
    this.metadata,
    this.selectedOrder,
    this.isLoadingMore = false,
  }) : ordersResource = ordersResource ?? Resource.initial();

  MyOrdersState copyWith({
    Resource<void>? ordersResource,
    List<OrderEntity>? orders,
    MetadataEntity? metadata,
    OrderEntity? selectedOrder,
    bool? isLoadingMore,
  }) {
    return MyOrdersState(
      ordersResource: ordersResource ?? this.ordersResource,
      orders: orders ?? this.orders,
      metadata: metadata ?? this.metadata,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
