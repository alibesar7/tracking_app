import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';

class DriverOrderState {
  final Resource<OrderResponse> orderResource;

  DriverOrderState({Resource<OrderResponse>? orderResource})
    : orderResource = orderResource ?? Resource.initial();

  DriverOrderState copyWith({Resource<OrderResponse>? orderResource}) {
    return DriverOrderState(orderResource: orderResource ?? this.orderResource);
  }
}
