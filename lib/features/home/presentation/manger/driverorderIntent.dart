import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';

sealed class DriverOrderIntent {}

class GetPendingOrders extends DriverOrderIntent {}

class RemoveOrder extends DriverOrderIntent {
  final Order order;
  RemoveOrder(this.order);
}

class AcceptOrder extends DriverOrderIntent {
  final Order order;
  AcceptOrder(this.order);
}
