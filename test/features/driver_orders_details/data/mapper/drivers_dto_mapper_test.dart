import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/drivers_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';

void main() {
  group('DriverDataDtoMapper', () {
    test('Convert DriverDataDto to DriverDataModel correctly', () {
      final dto = DriverDataDto(
        deviceToken: 'token',
        id: '111',
        phone: '0',
        currentLocation: DriverLocationDto(lat: 31, lng: 29),
        name: 'Mariam',
      );

      final result = dto.toDriversModel();

      expect(result, isA<DriverDataModel>());
      expect(result.deviceToken, dto.deviceToken);
      expect(result.name, dto.name);
      expect(result.phone, dto.phone);
      expect(result.currentLocation.lat, dto.currentLocation.lat);
    });
  });

  group('DriverLocationDtoMapper', () {
    test('Convert DriverLocationDto to DriverLocationModel correctly', () {
      final dto = DriverLocationDto(lat: 30, lng: 29);

      final result = dto.toDriverLocationModel();

      expect(result, isA<DriverLocationModel>());
      expect(result.lat, dto.lat);
      expect(result.lng, dto.lng);
    });
  });
}
