import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';

void main() {
  group('ChangePasswordModel', () {
    test('should create instance with correct values', () {
      final model = ChangePasswordModel(
        message: 'Change password successfully',
        error: null,
        token: '',
      );

      expect(model.message, 'Change password successfully');
      expect(model.error, null);
    });
  });
}
