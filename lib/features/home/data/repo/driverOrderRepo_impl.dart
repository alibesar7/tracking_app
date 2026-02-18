import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/datascourse/driverOrderDatascource.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';

@Injectable(as: DriverOrderRepo)
class DriverOrderRepositoryImpl implements DriverOrderRepo {
  final DriverOrderDataSource _dataSource;

  DriverOrderRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<OrderResponse>> getPendingOrders(String token) {
    return _dataSource.getPendingOrders(token);
  }
}
