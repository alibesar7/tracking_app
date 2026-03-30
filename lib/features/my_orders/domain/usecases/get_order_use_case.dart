import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/domain/repo/my_orders_repo.dart';

@injectable
class GetOrderUseCase {
  final MyOrdersRepo repo;

  GetOrderUseCase(this.repo);

  Future<ApiResult<MyOrdersResult>> call({
    required String token,
    int page = 1,
    int limit = 10,
  }) {
    return repo.getAllOrders(token: token, page: page, limit: limit);
  }
}
