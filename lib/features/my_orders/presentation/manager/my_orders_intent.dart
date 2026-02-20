import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

sealed class MyOrdersIntent {}

class GetMyOrdersIntent extends MyOrdersIntent {
  final int page;
  final int limit;

  GetMyOrdersIntent({this.page = 1, this.limit = 10});
}

class LoadMoreOrdersIntent extends MyOrdersIntent {}

class OpenOrderDetailsIntent extends MyOrdersIntent {
  final OrderEntity order;

  OpenOrderDetailsIntent(this.order);
}

class FilterCompletedOrdersIntent extends MyOrdersIntent {}

class FilterCancelledOrdersIntent extends MyOrdersIntent {}
