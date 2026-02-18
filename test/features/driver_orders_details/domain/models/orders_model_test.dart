import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

void main() {
  group('OrderModel & UserAddressModel Tests', () {
    test('should correctly initialize UserAddressModel with given values', () {
      final tAddress = UserAddressModel(address: 'Cairo', name: 'Mohamed');

      expect(tAddress.address, 'Cairo');
      expect(tAddress.name, 'Mohamed');
    });

    test('should correctly initialize OrderModel with given values', () {
      final tUserAddress = UserAddressModel(address: 'Cairo', name: 'Mohamed');

      final tOrder = OrderModel(
        driverId: 'DRV-101',
        id: 'ORD-999',
        status: 'picked_up',
        totalPrice: '250.50',
        userAddress: tUserAddress,
        userId: 'USR-555',
      );

      expect(tOrder.driverId, 'DRV-101');
      expect(tOrder.id, 'ORD-999');
      expect(tOrder.status, 'picked_up');
      expect(tOrder.totalPrice, '250.50');
      expect(tOrder.userId, 'USR-555');

      expect(tOrder.userAddress, isA<UserAddressModel>());
      expect(tOrder.userAddress.name, 'Mohamed');
    });

    test('should support equality check if needed (Optional)', () {
      final address1 = UserAddressModel(address: 'A', name: 'B');
      final address2 = UserAddressModel(address: 'A', name: 'B');

      expect(address1 == address2, isFalse);
    });
  });
}
