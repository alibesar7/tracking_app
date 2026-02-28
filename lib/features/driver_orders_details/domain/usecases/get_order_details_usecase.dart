import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class GetOrderDetailsUsecase {
  OrderDetailsRepo _repo;
  GetOrderDetailsUsecase({required OrderDetailsRepo repo}) : _repo = repo;

  ApiResult<Stream<OrderModel>> call(String orderId) =>
      _repo.getOrderDetails(orderId);
}
