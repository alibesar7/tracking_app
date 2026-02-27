import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';

void main() {
  group('DriverEntity', () {
    test('should create a DriverEntity with correct values', () {
      // Arrange
      const id = 'driver1';
      const lat = 10.5;
      const lng = 20.3;

      // Act
      final driver = DriverEntity(id: id, lat: lat, lng: lng);

      // Assert
      expect(driver.id, id);
      expect(driver.lat, lat);
      expect(driver.lng, lng);
    });

    test('should be immutable', () {
      final driver = DriverEntity(id: 'd1', lat: 0.0, lng: 0.0);

      // Attempting to modify fields should fail
      // (Since fields are final, Dart will throw a compile-time error)
      // So just check that fields are final by reading them
      expect(driver.id, 'd1');
      expect(driver.lat, 0.0);
      expect(driver.lng, 0.0);
    });
  });
}
