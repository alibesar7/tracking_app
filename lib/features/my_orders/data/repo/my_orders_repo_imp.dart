import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/data/datasource/my_orders_remote_data_source.dart';
import 'package:tracking_app/features/my_orders/data/mappers/metadata_mapper.dart';
import 'package:tracking_app/features/my_orders/data/mappers/order_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/response/my_order_response.dart';
import 'package:tracking_app/features/my_orders/domain/repo/my_orders_repo.dart';

@Injectable(as: MyOrdersRepo)
class MyOrdersRepoImpl implements MyOrdersRepo {
  final MyOrdersRemoteDataSource remoteDataSource;

  MyOrdersRepoImpl(this.remoteDataSource);

  @override
  Future<ApiResult<MyOrdersResult>> getAllOrders({
    required String token,
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final result = await remoteDataSource.getAllOrders(
        token: token,
        limit: limit,
        page: page,
      );

      if (result is SuccessApiResult<MyOrderResponse>) {
        final response = result.data;
        final orders = response.orders?.map((e) => e.toEntity()).toList() ?? [];
        final metadata = response.metadata?.toEntity();

        return SuccessApiResult(
          data: MyOrdersResult(orders: orders, metadata: metadata),
        );
      } else if (result is ErrorApiResult<MyOrderResponse>) {
        return ErrorApiResult(error: result.error);
      } else {
        return ErrorApiResult(error: 'Unknown error');
      }
    } catch (e) {
      return ErrorApiResult(error: e.toString());
    }
  }
}
