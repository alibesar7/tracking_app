import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';

void main() {
  group('OrderEntity', () {
    test('should create an OrderEntity with all fields', () {
      // Arrange
      const id = 'o1';
      const userId = 'u1';
      const status = 'delivered';
      const driverId = 'd1';
      const totalPrice = '100';
      const pickupAddress = 'Store Street';
      const pickupName = 'Flower Shop';
      const userAddress = 'Home Avenue';
      const userName = 'John Doe';

      // Act
      final order = OrderEntity(
        id: id,
        userId: userId,
        status: status,
        driverId: driverId,
        totalPrice: totalPrice,
        pickupAddress: pickupAddress,
        pickupName: pickupName,
        userAddress: userAddress,
        userName: userName,
      );

      // Assert
      expect(order.id, id);
      expect(order.userId, userId);
      expect(order.status, status);
      expect(order.driverId, driverId);
      expect(order.totalPrice, totalPrice);
      expect(order.pickupAddress, pickupAddress);
      expect(order.pickupName, pickupName);
      expect(order.userAddress, userAddress);
      expect(order.userName, userName);
    });

    test('should create an OrderEntity with only required fields', () {
      // Arrange
      const id = 'o2';
      const userId = 'u2';
      const status = 'pending';

      // Act
      final order = OrderEntity(id: id, userId: userId, status: status);

      // Assert
      expect(order.id, id);
      expect(order.userId, userId);
      expect(order.status, status);
      expect(order.driverId, isNull);
      expect(order.totalPrice, isNull);
      expect(order.pickupAddress, isNull);
      expect(order.pickupName, isNull);
      expect(order.userAddress, isNull);
      expect(order.userName, isNull);
    });
  });
}
