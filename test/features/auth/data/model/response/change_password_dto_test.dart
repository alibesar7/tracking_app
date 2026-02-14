import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';

void main() {
  group('ChangePasswordDto Json serialization', () {
    test('fromJson should parse correctly', () {
      final json = {
        'message': 'change pass successfully',
        'token': '',
        'error': null,
      };

      final result = ChangePasswordDto.fromJson(json);
      expect(result.message, 'change pass successfully');
    });
    test('toJson should parse correctly', () {
      final dto = ChangePasswordDto(
        message: 'success',
        error: 'error message',
        token: '',
      );

      expect(dto.message, 'success');
      expect(dto.error, 'error message');
    });
  });
}
