import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class GetDriverDataUsecase {
  OrderDetailsRepo _repo;
  GetDriverDataUsecase({required OrderDetailsRepo repo}) : _repo = repo;

  ApiResult<Stream<DriverDataModel>> call(String driverId) =>
      _repo.getDriverData(driverId);
}
