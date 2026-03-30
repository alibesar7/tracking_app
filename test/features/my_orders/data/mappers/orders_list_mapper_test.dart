import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/orders_list_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/order_model.dart';
import 'package:tracking_app/features/my_orders/data/models/user_model.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';

void main() {
  group('OrdersListMapper', () {
    test('should map List<Order> to List<OrderEntity> correctly', () {
      final list = [
        Order(
          id: 'o1',
          user: User(id: 'u1'),
        ),
        Order(
          id: 'o2',
          user: User(id: 'u2'),
        ),
      ];

      final result = list.toEntityList();

      expect(result, isA<List<OrderEntity>>());
      expect(result.length, 2);
      expect(result[0].id, 'o1');
      expect(result[1].id, 'o2');
    });

    test('should map empty List<Order> to empty List<OrderEntity>', () {
      final list = <Order>[];

      final result = list.toEntityList();

      expect(result, isEmpty);
    });
  });
}
