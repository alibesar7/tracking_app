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
      const address = '123 Street';
      const name = 'John Doe';

      // Act
      final order = OrderEntity(
        id: id,
        userId: userId,
        status: status,
        driverId: driverId,
        totalPrice: totalPrice,
        address: address,
        name: name,
      );

      // Assert
      expect(order.id, id);
      expect(order.userId, userId);
      expect(order.status, status);
      expect(order.driverId, driverId);
      expect(order.totalPrice, totalPrice);
      expect(order.address, address);
      expect(order.name, name);
    });

    test('should create an OrderEntity with only required fields', () {
      // Arrange
      const id = 'o2';
      const userId = 'u2';
      const status = 'pending';

      // Act
      final order = OrderEntity(
        id: id,
        userId: userId,
        status: status,
      );

      // Assert
      expect(order.id, id);
      expect(order.userId, userId);
      expect(order.status, status);
      expect(order.driverId, isNull);
      expect(order.totalPrice, isNull);
      expect(order.address, isNull);
      expect(order.name, isNull);
    });
  });
}