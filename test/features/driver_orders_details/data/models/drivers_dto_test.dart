import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';

void main() {
  group('DriverDataDto Tests', () {
    test('should return a valid DriverDataDto from JSON', () {
      final Map<String, dynamic> json = {
        'id': '6989f35de364ef61405211a0',
        'currentLocation': {'lat': 31.251555, 'lng': 29.9843417},
        'name': "mariam",
        'phone': '01205708282',
        'deviceToken': '',
      };

      final result = DriverDataDto.fromJson(json);

      expect(result.phone, '01205708282');
      expect(result.name, 'mariam');
      expect(result.id, '6989f35de364ef61405211a0');
      expect(result.currentLocation.lat, 31.251555);
    });

    test('should return a valid JSON map from DriverDataDto', () {
      final dto = DriverDataDto(
        currentLocation: DriverLocationDto(lat: 30, lng: 29),
        deviceToken: 'token',
        id: '123',
        phone: '01205708282',
        name: 'Mariam',
      );

      final result = dto.toJson();

      expect(result['deviceToken'], 'token');
      expect(result['name'], 'Mariam');
      expect(result['id'], '123');
    });
  });

  group('DriverLocationDto Tests', () {
    test('should return a valid DriverLocationDto from JSON', () {
      final Map<String, dynamic> json = {'lat': 30, 'lng': 29};

      final result = DriverLocationDto.fromJson(json);

      expect(result.lat, 30);
      expect(result.lng, 29);
    });

    test('should return a valid JSON map from DriverLocationDto', () {
      final dto = DriverLocationDto(lat: 30, lng: 29);

      final result = dto.toJson();

      expect(result['lat'], 30);
      expect(result['lng'], 29);
    });
  });
}
