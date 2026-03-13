import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class LocationUsecase {
  final OrderDetailsRepo _repo;

  LocationUsecase(this._repo);

  Future<ApiResult<LatLng?>> getAddress(String address) {
    return _repo.getLatLngFromAddress(address);
  }

  Future<ApiResult<List<LatLng>>> getRealRoute(
    LatLng driverLocation,
    LatLng destination,
  ) {
    return _repo.getRealRoute(driverLocation, destination);
  }

  Future<void> updateDriverLocation(String driverId, double lat, double lng) {
    return _repo.updateDriverLocation(driverId, lat, lng);
  }
}
