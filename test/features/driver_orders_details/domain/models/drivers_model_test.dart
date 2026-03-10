import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';

void main() {
  group('DriverDataModel Tests', () {
    test('should correctly initialize DriverDataModel with given values', () {
      final dataModel = DriverDataModel(
        name: 'mariam',
        id: '1',
        phone: '01205708282',
        deviceToken: 'token',
        currentLocation: DriverLocationModel(lat: 30, lng: 29),
      );

      expect(dataModel.name, 'mariam');
      expect(dataModel.currentLocation.lat, 30);
      expect(dataModel.id, '1');
    });

    test(
      'should correctly initialize DriverLocationModel with given values',
      () {
        final location = DriverLocationModel(lat: 30, lng: 29);

        expect(location.lat, 30);
        expect(location.lng, 29);
      },
    );
  });
}
