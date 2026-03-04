import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';

void main() {
  group('DriverEntity', () {
    test('should create a DriverEntity with correct values', () {
      // Arrange
      const id = 'driver1';
      const lat = 10.5;
      const lng = 20.3;
      const name = 'John Doe';
      const phone = '01234567890';
      const deviceToken = 'token123';

      // Act
      const driver = DriverEntity(
        id: id,
        lat: lat,
        lng: lng,
        name: name,
        phone: phone,
        deviceToken: deviceToken,
      );

      // Assert
      expect(driver.id, id);
      expect(driver.lat, lat);
      expect(driver.lng, lng);
      expect(driver.name, name);
      expect(driver.phone, phone);
      expect(driver.deviceToken, deviceToken);
    });

    test('should support value equality', () {
      const driver1 = DriverEntity(
        id: 'd1',
        lat: 0.0,
        lng: 0.0,
        name: 'a',
        phone: '1',
        deviceToken: 't1',
      );
      const driver2 = DriverEntity(
        id: 'd1',
        lat: 0.0,
        lng: 0.0,
        name: 'a',
        phone: '1',
        deviceToken: 't1',
      );

      expect(driver1, driver2);
    });
  });
}
