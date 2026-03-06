import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class UpdateOrderStateUsecase {
  final OrderDetailsRepo _repo;

  UpdateOrderStateUsecase({required OrderDetailsRepo repo}) : _repo = repo;

  Future<ApiResult<void>> call(UpdateOrderStateParams params) =>
      _repo.updateOrderState(params);
}
