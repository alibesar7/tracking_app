import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/datascourse/driverOrderDatascource.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';

@Injectable(as: DriverOrderRepo)
class DriverOrderRepositoryImpl implements DriverOrderRepo {
  final DriverOrderDataSource _dataSource;

  DriverOrderRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<OrderResponse>> getPendingOrders(String token) {
    return _dataSource.getPendingOrders(token);
  }

  @override
  Future<ApiResult<EditProfileResponse>> getProfile(String token) {
    return _dataSource.getProfile(token);
  }
}
