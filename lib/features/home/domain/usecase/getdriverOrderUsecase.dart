import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';

@injectable
class GetDriverOrdersUseCase {
  final DriverOrderRepo _repository;

  GetDriverOrdersUseCase(this._repository);

  Future<ApiResult<OrderResponse>> call(String token) {
    return _repository.getPendingOrders(token);
  }
}
