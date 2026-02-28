import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/order_item_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/order_item_model.dart';
import 'package:tracking_app/features/my_orders/data/models/product_model.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';

void main() {
  group('OrderItemMapper', () {
    test('should map OrderItem model to OrderItemEntity correctly', () {
      final model = OrderItem(
        id: 'i1',
        product: Product(id: 'p1', price: 100),
        price: 100,
        quantity: 2,
      );

      final result = model.toEntity();

      expect(result, isA<OrderItemEntity>());
      expect(result.product.id, 'p1');
      expect(result.price, 100);
      expect(result.quantity, 2);
    });

    test(
      'should map OrderItem model with null fields to OrderItemEntity with default values',
      () {
        final model = OrderItem(
          id: null,
          product: null,
          price: null,
          quantity: null,
        );

        final result = model.toEntity();

        expect(result.product.id, '');
        expect(result.price, 0);
        expect(result.quantity, 0);
      },
    );
  });
}
