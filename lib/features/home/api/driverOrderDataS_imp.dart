import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/home/data/datascourse/driverOrderDatascource.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';

@Injectable(as: DriverOrderDataSource)
class DriverOrderDataSourceImpl implements DriverOrderDataSource {
  final ApiClient _apiClient;

  DriverOrderDataSourceImpl(this._apiClient);

  @override
  Future<ApiResult<OrderResponse>> getPendingOrders(String token) {
    return safeApiCall(call: () => _apiClient.getPendingOrders(token));
  }
}
