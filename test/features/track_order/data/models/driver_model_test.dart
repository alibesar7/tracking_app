import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';

void main() {
  group('DriverModel.fromFirestore', () {

    test('creates DriverModel correctly from map', () {
      final data = {
        'lat': 30.5,
        'lng': 31.2,
      };

      final model = DriverModel.fromFirestore('driver1', data);

      expect(model.id, 'driver1');
      expect(model.lat, 30.5);
      expect(model.lng, 31.2);
    });

    test('converts int to double', () {
      final data = {
        'lat': 30,
        'lng': 31,
      };

      final model = DriverModel.fromFirestore('driver2', data);

      expect(model.lat, 30.0);
      expect(model.lng, 31.0);
    });

    test('throws error if lat is missing', () {
      final data = {
        'lng': 31,
      };

      expect(
        () => DriverModel.fromFirestore('driver3', data),
        throwsA(isA<TypeError>()),
      );
    });

  });
}