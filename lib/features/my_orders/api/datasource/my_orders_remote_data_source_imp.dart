import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/my_orders/data/datasource/my_orders_remote_data_source.dart';
import 'package:tracking_app/features/my_orders/data/models/response/my_order_response.dart';

@Injectable(as: MyOrdersRemoteDataSource)
class MyOrdersRemoteDataSourceImp extends MyOrdersRemoteDataSource {
  final ApiClient apiClient;
  MyOrdersRemoteDataSourceImp(this.apiClient);

  @override
  Future<ApiResult<MyOrderResponse>> getAllOrders({
    required String token,
    int limit = 10,
    int page = 1,
  }) {
    return safeApiCall<MyOrderResponse>(
      call: () =>
          apiClient.getAllOrders(token: token, limit: limit, page: page),
    );
  }
}
