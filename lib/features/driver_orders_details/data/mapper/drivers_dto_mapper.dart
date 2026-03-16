import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';

extension DriversDtoMapper on DriverDataDto {
  DriverDataModel toDriversModel() {
    return DriverDataModel(
      name: name,
      phone: phone,
      id: id,
      deviceToken: deviceToken,
      currentLocation: currentLocation.toDriverLocationModel(),
    );
  }
}

extension DriverLocationDtoMapper on DriverLocationDto {
  DriverLocationModel toDriverLocationModel() {
    return DriverLocationModel(lat: lat, lng: lng);
  }
}
