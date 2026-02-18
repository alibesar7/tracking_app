import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

abstract class OrderDetailsRepo {
  Stream<OrderModel> getOrderDetails(String orderId);
}
