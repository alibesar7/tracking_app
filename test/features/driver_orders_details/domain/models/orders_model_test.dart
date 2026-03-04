import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

void main() {
  group('OrderModel & UserAddressModel Tests', () {
    test('should correctly initialize UserAddressModel with given values', () {
      final tAddress = UserAddressModel(
        address: 'Cairo',
        name: 'Mohamed',
        userId: '1',
      );

      expect(tAddress.address, 'Cairo');
      expect(tAddress.name, 'Mohamed');
      expect(tAddress.userId, '1');
    });

    test('should correctly initialize OrderModel with given values', () {
      final tUserAddress = UserAddressModel(
        address: 'Cairo',
        name: 'Mohamed',
        userId: 'USR-555',
      );

      final tOrder = OrderModel(
        driverId: 'DRV-101',
        userAddress: tUserAddress,
        userId: 'USR-555',
        orderId: 'ORD-999',
        orderDetails: OrderDetailsModel(
          items: [],
          status: 'picked_up',
          totalPrice: 250,
          pickupAddress: PickedAddressModel(
            name: 'Pharmacy',
            address: 'Downtown',
          ),
          orderId: 'ORD-999',
          userAddress: 'Cairo',
        ),
      );

      expect(tOrder.driverId, 'DRV-101');
      expect(tOrder.orderId, 'ORD-999');
      expect(tOrder.orderDetails.status, 'picked_up');
      expect(tOrder.orderDetails.totalPrice, 250);
      expect(tOrder.userId, 'USR-555');

      expect(tOrder.userAddress, isA<UserAddressModel>());
      expect(tOrder.userAddress.name, 'Mohamed');
    });

    test('should support equality check if needed (Optional)', () {
      final address1 = UserAddressModel(
        address: 'A',
        name: 'B',
        userId: 'USR-123',
      );
      final address2 = UserAddressModel(
        address: 'A',
        name: 'B',
        userId: 'USR-456',
      );

      expect(address1 == address2, isFalse);
    });
  });
}
