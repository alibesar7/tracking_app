import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/user_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/user_model.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';

void main() {
  group('UserMapper', () {
    test('should map User model to UserEntity correctly', () {
      final model = User(
        id: 'u1',
        firstName: 'Noor',
        lastName: 'Mohamed',
        phone: '01012345678',
        photo: 'photo_url',
      );

      final result = model.toEntity();

      expect(result, isA<UserEntity>());
      expect(result.id, 'u1');
      expect(result.firstName, 'Noor');
      expect(result.lastName, 'Mohamed');
      expect(result.phone, '01012345678');
      expect(result.photo, 'photo_url');
    });

    test(
      'should map User model with null fields to UserEntity with default values',
      () {
        final model = User(
          id: null,
          firstName: null,
          lastName: null,
          phone: null,
          photo: null,
        );

        final result = model.toEntity();

        expect(result.id, '');
        expect(result.firstName, '');
        expect(result.lastName, '');
        expect(result.phone, '');
        expect(result.photo, '');
      },
    );
  });
}
