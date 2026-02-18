import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

void main() {
  group('UserAddressDto Tests', () {
    test('should return a valid UserAddressDto from JSON', () {
      final Map<String, dynamic> json = {'address': 'Alex', 'name': 'Mariam'};

      final result = UserAddressDto.fromJson(json);

      expect(result.address, 'Alex');
      expect(result.name, 'Mariam');
    });

    test('should return a valid JSON map from UserAddressDto', () {
      final dto = UserAddressDto(address: 'Alex', name: 'Mariam');

      final result = dto.toJson();

      expect(result['address'], 'Alex');
      expect(result['name'], 'Mariam');
    });
  });

  group('OrderDto Tests', () {
    final Map<String, dynamic> tOrderJsonWithSpace = {
      'driverId': 'D123',
      'id': 'O456',
      'status': 'accepted',
      'totalPrice': '150.0',
      'userAddress ': {'address': 'Alex', 'name': 'Mariam'},
      'userId': 'U789',
    };

    test(
      'should correctly parse userAddress when key has a trailing space',
      () {
        final result = OrderDto.fromJson(tOrderJsonWithSpace);

        expect(result.userAddress.name, 'Mariam');
        expect(result.userAddress.address, 'Alex');
        expect(result.id, 'O456');
      },
    );

    test(
      'should return default address values when userAddress key is missing or null',
      () {
        final Map<String, dynamic> jsonMissingAddress = {
          'driverId': 'D123',
          'id': 'O456',
          'status': 'accepted',
          'totalPrice': '150.0',
          'userId': 'U789',
        };

        final result = OrderDto.fromJson(jsonMissingAddress);

        expect(result.userAddress.name, 'No Name');
        expect(result.userAddress.address, 'No Address');
      },
    );

    test('should return a valid JSON map from OrderDto', () {
      final dto = OrderDto(
        driverId: 'D1',
        id: 'O1',
        status: 'pickup',
        totalPrice: '100',
        userAddress: UserAddressDto(address: 'Alex', name: 'Mariam'),
        userId: 'U1',
      );

      final result = dto.toJson();

      expect(result['driverId'], 'D1');
      expect(result['userAddress']['name'], 'Mariam');
      expect(result.containsKey('userAddress'), true);
    });
  });
}
