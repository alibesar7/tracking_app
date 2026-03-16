import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class GetAddressUsecase {
  final OrderDetailsRepo _repo;

  GetAddressUsecase(this._repo);

  Future<ApiResult<LatLng?>> getAddress(String address) {
    return _repo.getLatLngFromAddress(address);
  }
}
