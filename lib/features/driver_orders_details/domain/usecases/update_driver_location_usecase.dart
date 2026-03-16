import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class UpdateDriverLocationUsecase {
  final OrderDetailsRepo _repo;

  UpdateDriverLocationUsecase(this._repo);

  Future<void> updateDriverLocation(String driverId, double lat, double lng) {
    return _repo.updateDriverLocation(driverId, lat, lng);
  }
}
