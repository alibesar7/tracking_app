
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';

extension VehiclesResponseExtention on VehicleModel {
  VehicleModel toVehicleType() {
    return VehicleModel(
      type: type ?? "",
      id: id
    );
  }
}