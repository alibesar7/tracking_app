import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

class OrderDetailsStates {
  final Resource<OrderModel>? data;
  const OrderDetailsStates({this.data});

  OrderDetailsStates copyWith({Resource<OrderModel>? data}) {
    return OrderDetailsStates(data: data ?? this.data);
  }
}
