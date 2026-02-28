import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/order_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/order_model.dart';
import 'package:tracking_app/features/my_orders/data/models/user_model.dart';
import 'package:tracking_app/features/my_orders/data/models/store_model.dart';
import 'package:tracking_app/features/my_orders/data/models/order_item_model.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

void main() {
  group('OrderMapper', () {
    test('should map Order model to OrderEntity correctly', () {
      final model = Order(
        id: 'o1',
        user: User(id: 'u1', firstName: 'Noor', lastName: 'Mohamed'),
        store: Store(name: 'Store Name'),
        address: 'User Address',
        orderItems: [OrderItem(price: 100, quantity: 1)],
        totalPrice: 100,
        paymentType: 'Cash',
        isPaid: true,
        isDelivered: true,
        state: 'Delivered',
        createdAt: '2023-01-01',
        orderNumber: 'ORD123',
      );

      final result = model.toEntity();

      expect(result, isA<OrderEntity>());
      expect(result.id, 'o1');
      expect(result.user.id, 'u1');
      expect(result.store?.name, 'Store Name');
      expect(result.address, 'User Address');
      expect(result.items.length, 1);
      expect(result.totalPrice, 100);
      expect(result.paymentType, 'Cash');
      expect(result.isPaid, true);
      expect(result.isDelivered, true);
      expect(result.state, 'Delivered');
      expect(result.createdAt, '2023-01-01');
      expect(result.orderNumber, 'ORD123');
    });

    test(
      'should map Order model with null fields to OrderEntity with default values',
      () {
        final model = Order(
          id: null,
          user: User(id: null),
          store: null,
          address: null,
          orderItems: null,
          totalPrice: null,
          paymentType: null,
          isPaid: null,
          isDelivered: null,
          state: null,
          createdAt: null,
          orderNumber: null,
        );

        final result = model.toEntity();

        expect(result.id, '');
        expect(result.user.id, '');
        expect(result.store, isNull);
        expect(result.address, '');
        expect(result.items, isEmpty);
        expect(result.totalPrice, 0);
        expect(result.paymentType, '');
        expect(result.isPaid, false);
        expect(result.isDelivered, false);
        expect(result.state, '');
        expect(result.createdAt, '');
        expect(result.orderNumber, '');
      },
    );
  });
}
