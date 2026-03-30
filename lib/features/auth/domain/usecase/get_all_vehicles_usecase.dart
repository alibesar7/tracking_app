import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';

import '../../../../app/core/network/api_result.dart';
import '../repos/auth_repo.dart';

@lazySingleton
class GetAllVehiclesUseCase {
  final AuthRepo repo;

  GetAllVehiclesUseCase(this.repo);

  Future<ApiResult<List<VehicleModel>>> call() {
    return repo.getAllVehicles();
  }
}
