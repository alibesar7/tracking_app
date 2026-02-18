import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class GetOrderDetailsUsecase {
  OrderDetailsRepo repo;
  GetOrderDetailsUsecase({required this.repo});

  Stream<OrderModel> call(String orderId) => repo.getOrderDetails(orderId);
}
