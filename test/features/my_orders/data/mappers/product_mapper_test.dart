import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/product_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/product_model.dart';
import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';

void main() {
  group('ProductMapper', () {
    test('should map Product model to ProductEntity correctly', () {
      final model = Product(id: 'p1', price: 100);

      final result = model.toEntity();

      expect(result, isA<ProductEntity>());
      expect(result.id, 'p1');
      expect(result.price, 100);
    });

    test(
      'should map Product model with null fields to ProductEntity with default values',
      () {
        final model = Product(id: null, price: null);

        final result = model.toEntity();

        expect(result.id, '');
        expect(result.price, 0);
      },
    );
  });
}
