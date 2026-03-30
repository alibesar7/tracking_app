import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/store_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/store_model.dart';
import 'package:tracking_app/features/my_orders/domain/models/store_entity.dart';

void main() {
  group('StoreMapper', () {
    test('should map Store model to StoreEntity correctly', () {
      final model = Store(
        name: 'Store Name',
        image: 'image_url',
        address: 'Store Address',
        phoneNumber: '01012345678',
      );

      final result = model.toEntity();

      expect(result, isA<StoreEntity>());
      expect(result.name, 'Store Name');
      expect(result.image, 'image_url');
      expect(result.address, 'Store Address');
      expect(result.phoneNumber, '01012345678');
    });

    test(
      'should map Store model with null fields to StoreEntity with default values',
      () {
        final model = Store(
          name: null,
          image: null,
          address: null,
          phoneNumber: null,
        );

        final result = model.toEntity();

        expect(result.name, '');
        expect(result.image, '');
        expect(result.address, '');
        expect(result.phoneNumber, '');
      },
    );
  });
}
